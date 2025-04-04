#!/usr/bin/env python3

import os
import sys
import pandas as pd
import fitz  # PyMuPDF
import csv
import logging
from datetime import datetime

# Set up logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler("pdf_converter.log"),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

# Ensure directories exist
def ensure_dirs():
    """Create necessary directories if they don't exist"""
    os.makedirs("pdf_imports", exist_ok=True)
    os.makedirs("pdf_conversions", exist_ok=True)

def extract_tables_from_pdf(pdf_path):
    """Extract tables from PDF using PyMuPDF"""
    try:
        logger.info(f"Processing {pdf_path}")
        doc = fitz.open(pdf_path)
        
        # Extract text from all pages
        all_text = []
        for page_num in range(len(doc)):
            page = doc.load_page(page_num)
            all_text.append(page.get_text())
        
        text_content = "\n".join(all_text)
        
        # Split into lines
        lines = [line.strip() for line in text_content.split('\n') if line.strip()]
        
        # Try to find table structure
        header_line = None
        for i, line in enumerate(lines):
            # Look for potential headers
            if any(keyword in line.lower() for keyword in ['id', 'name', 'item', 'size', 'category', 'price']):
                header_line = i
                break
        
        if header_line is None:
            logger.warning(f"No table header found in {pdf_path}")
            return None
        
        # Extract header columns
        headers = lines[header_line].split()
        
        # Process data rows
        data = []
        for line in lines[header_line+1:]:
            # Skip lines that are too short
            if len(line.split()) < 3:
                continue
                
            # Split line into columns, preserving quoted values
            cols = line.split()
            
            # Ensure we have the right number of columns
            # If too many, combine excess columns into the last expected column
            if len(cols) > len(headers):
                cols = cols[:len(headers)-1] + [' '.join(cols[len(headers)-1:])]
            
            # If too few, add empty values
            while len(cols) < len(headers):
                cols.append("review")
                
            data.append(cols)
        
        # Convert to DataFrame
        df = pd.DataFrame(data, columns=headers)
        return df
        
    except Exception as e:
        logger.error(f"Error extracting tables from {pdf_path}: {str(e)}")
        return None

def clean_and_validate_data(df):
    """Clean and validate the data, filling missing values with 'review'"""
    if df is None or df.empty:
        return None
    
    # Standard column names we expect
    standard_columns = ['id', 'name', 'category', 'size', 'status', 'price', 'location', 'condition']
    
    # Map actual columns to standard columns
    column_mapping = {}
    for std_col in standard_columns:
        # Try to find matching column
        for actual_col in df.columns:
            if std_col.lower() in actual_col.lower():
                column_mapping[std_col] = actual_col
                break
    
    # Create new DataFrame with standard columns
    new_df = pd.DataFrame()
    
    # Fill in mapped columns
    for std_col in standard_columns:
        if std_col in column_mapping:
            new_df[std_col] = df[column_mapping[std_col]]
        else:
            # For missing columns, fill with "review"
            new_df[std_col] = "review"
    
    # Generate IDs if missing
    if 'id' not in column_mapping or new_df['id'].isnull().any():
        # Check if we have some IDs
        has_some_ids = 'id' in column_mapping and not new_df['id'].isnull().all()
        
        # For rows with missing IDs
        for idx in new_df.index[new_df['id'] == "review"]:
            if 'name' in column_mapping and new_df.loc[idx, 'name'] != "review":
                # Create ID from name
                name = new_df.loc[idx, 'name']
                name_prefix = ''.join(c for c in name.lower() if c.isalnum())[:5]
                new_df.loc[idx, 'id'] = f"{name_prefix}{idx:03d}"
            else:
                # Create generic ID
                new_df.loc[idx, 'id'] = f"item{idx:03d}"
    
    # Ensure status is valid
    valid_statuses = ['Available', 'In Use', 'Cleaning', 'In Repair']
    for idx in new_df.index:
        status = new_df.loc[idx, 'status']
        if status == "review" or status not in valid_statuses:
            new_df.loc[idx, 'status'] = 'Available'
    
    return new_df

def convert_to_csv(df, output_path):
    """Convert DataFrame to CSV file"""
    try:
        if df is not None and not df.empty:
            df.to_csv(output_path, index=False, quoting=csv.QUOTE_NONNUMERIC)
            logger.info(f"Successfully wrote {output_path}")
            return True
        else:
            logger.warning(f"No data to write to {output_path}")
            return False
    except Exception as e:
        logger.error(f"Error writing CSV to {output_path}: {str(e)}")
        return False

def process_pdf_files():
    """Process all PDF files in the pdf_imports directory"""
    ensure_dirs()
    
    pdf_dir = "pdf_imports"
    csv_dir = "pdf_conversions"
    
    # Get all PDF files
    pdf_files = [f for f in os.listdir(pdf_dir) if f.lower().endswith('.pdf')]
    
    if not pdf_files:
        logger.info("No PDF files found in pdf_imports directory")
        return
    
    logger.info(f"Found {len(pdf_files)} PDF files to process")
    
    processed = 0
    failed = 0
    
    for pdf_file in pdf_files:
        pdf_path = os.path.join(pdf_dir, pdf_file)
        csv_file = os.path.splitext(pdf_file)[0] + '.csv'
        csv_path = os.path.join(csv_dir, csv_file)
        
        # Extract tables
        df = extract_tables_from_pdf(pdf_path)
        
        if df is not None:
            # Clean and validate
            clean_df = clean_and_validate_data(df)
            
            # Write to CSV
            if convert_to_csv(clean_df, csv_path):
                processed += 1
            else:
                failed += 1
        else:
            failed += 1
    
    logger.info(f"Processed {processed} files successfully, {failed} files failed")

if __name__ == "__main__":
    logger.info("Starting PDF to CSV conversion")
    process_pdf_files()
    logger.info("Conversion process complete")
