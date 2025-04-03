#!/usr/bin/env python3
"""
PDF to CSV Converter for Costume Scheduler Inventory
--------------------------------------------------
This script converts PDF inventory files to CSV format for importing 
into the Costume Scheduler system.

Requirements:
- pdfplumber (pip install pdfplumber)
- pandas (pip install pandas)

Usage:
python3 pdf_to_csv.py
"""

import os
import pdfplumber
import pandas as pd
import csv
import re
from datetime import datetime

# Directory paths
INPUT_DIR = "pdf_imports"
OUTPUT_DIR = "pdf_conversions"

# Create output directory if it doesn't exist
if not os.path.exists(OUTPUT_DIR):
    os.makedirs(OUTPUT_DIR)

# Expected columns in output CSV
EXPECTED_COLUMNS = [
    "id", "name", "category", "size", "status", 
    "price", "location", "condition", "notes"
]

def extract_tables_from_pdf(pdf_path):
    """Extract tables from PDF file using pdfplumber."""
    tables = []
    try:
        with pdfplumber.open(pdf_path) as pdf:
            for page in pdf.pages:
                page_tables = page.extract_tables()
                if page_tables:
                    tables.extend(page_tables)
    except Exception as e:
        print(f"Error extracting tables from {pdf_path}: {e}")
    return tables

def process_table_data(tables):
    """Process extracted table data into a structured format."""
    if not tables:
        return []

    items = []
    
    # Try to determine header row
    header_row = tables[0][0]
    
    # Map headers to expected columns
    column_map = {}
    for i, header in enumerate(header_row):
        if not header:
            continue
            
        header = header.lower().strip()
        
        # Map various header names to standard columns
        if re.search(r'id|code|item.?number', header):
            column_map[i] = 'id'
        elif re.search(r'name|description|title', header):
            column_map[i] = 'name'
        elif re.search(r'category|type|class', header):
            column_map[i] = 'category'
        elif re.search(r'size|dimension', header):
            column_map[i] = 'size'
        elif re.search(r'status|availability|state', header):
            column_map[i] = 'status'
        elif re.search(r'price|cost|value', header):
            column_map[i] = 'price'
        elif re.search(r'location|storage|place', header):
            column_map[i] = 'location'
        elif re.search(r'condition|quality|state', header):
            column_map[i] = 'condition'
        elif re.search(r'notes|comments|details', header):
            column_map[i] = 'notes'
    
    # Process data rows
    for table in tables:
        for row in table[1:]:  # Skip header row
            item = {col: "review" for col in EXPECTED_COLUMNS}  # Default all fields to "review"
            
            for i, cell in enumerate(row):
                if i in column_map and cell:
                    item[column_map[i]] = cell.strip()
            
            # Generate ID if missing
            if item['id'] == "review":
                if item['category'] != "review" and item['name'] != "review":
                    # Create ID from category and name
                    category_prefix = ''.join(c for c in item['category'] if c.isalnum())[:3].lower()
                    item['id'] = f"{category_prefix}{len(items):03d}"
            
            items.append(item)
    
    return items

def save_to_csv(items, output_path):
    """Save processed items to CSV file."""
    if not items:
        print(f"No data to save to {output_path}")
        return False
    
    try:
        with open(output_path, 'w', newline='', encoding='utf-8') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=EXPECTED_COLUMNS)
            writer.writeheader()
            for item in items:
                writer.writerow(item)
        return True
    except Exception as e:
        print(f"Error saving to CSV {output_path}: {e}")
        return False

def main():
    """Main function to process all PDF files in input directory."""
    pdf_files = [f for f in os.listdir(INPUT_DIR) if f.lower().endswith('.pdf')]
    
    if not pdf_files:
        print(f"No PDF files found in {INPUT_DIR}")
        return
    
    print(f"Found {len(pdf_files)} PDF files to process")
    
    for pdf_file in pdf_files:
        pdf_path = os.path.join(INPUT_DIR, pdf_file)
        output_path = os.path.join(OUTPUT_DIR, f"{os.path.splitext(pdf_file)[0]}.csv")
        
        print(f"Processing {pdf_file}...")
        
        # Extract tables from PDF
        tables = extract_tables_from_pdf(pdf_path)
        
        if not tables:
            print(f"No tables found in {pdf_file}")
            continue
        
        # Process table data
        items = process_table_data(tables)
        
        if not items:
            print(f"No valid data extracted from {pdf_file}")
            continue
        
        # Save to CSV
        if save_to_csv(items, output_path):
            print(f"Successfully converted {pdf_file} to CSV at {output_path}")
            print(f"Extracted {len(items)} inventory items")
        else:
            print(f"Failed to save CSV for {pdf_file}")

if __name__ == "__main__":
    main()
