#!/usr/bin/env python3

import os
import sys
import pandas as pd
import csv
import logging
from datetime import datetime
import traceback

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
    """Create"""Create necessary directories if they don't exist"""
    os.makedirs("pdf_imports", exist_ok=True)
    os.makedirs("pdf_conversions", exist_ok=True)

def extract_text_from_pdf(pdf_path):
    """Extract text from PDF using PyMuPDF"""
    try:
        import fitz  # PyMuPDF
        
        logger.info(f"Processing {pdf_path}")
        doc = fitz.open(pdf_path)
        
        # Extract text from all pages
        all_text = []
        for page_num in range(len(doc)):
            page = doc.load_page(page_num)
            all_text.append(page.get_text())
        
        return "\n".join(all_text)
    except ImportError:
        logger.error("PyMuPDF (fitz) not installed. Install with: pip install PyMuPDF")
        return None
    except Exception as e:
        logger.error(f"Error extracting text from {pdf_path}: {str(e)}")
        return None

def parse_text_into_data(text_content):
    """Parse text content into structured data"""
    if not text_content:
        return None
    
    # Split into lines
    lines = [line.strip() for line in text_content.split('\n') if line.strip()]
    
    # Try to find table structure
    header_line = None
    for i, line in enumerate(lines):
        # Look for potential headers
        if any(keyword in line.lower() for keyword in ['id', 'name', 'item', 'size', 'category', 'price', 'costume']):
            header_line = i
            break
    
    if header_line is None:
        logger.warning("No table header found in the text")
        return None
    
    # Extract header columns
    header = lines[header_line].split()
    
    # Process data rows
    data = []
    for line in lines[header_line+1:]:
        # Skip lines that are too short
        if len(line.split()) < 3:
            continue
            
        # Split line into columns
        cols = line.split()
        
        # Ensure we have the right number of columns
        # If too many, combine excess columns into the last expected column
        if len(cols) > len(header):
            cols = cols[:len(header)-1] + [' '.join(cols[len(header)-1:])]
        
        # If too few, add "review" values
        while len(cols) < len(header):
            cols.append("review")
            
        data.append(dict(zip(header, cols)))
    
    return data

def save_to_csv(data, output_path):
    """Save parsed data to CSV file"""
    if not data:
        logger.warning(f"No data to save to {output_path}")
        return False
    
    try:
        # Get all field names
        fields = set()
        for item in data:
            fields.update(item.keys())
        
        fields = sorted(list(fields))
        
        # Write to CSV
        with open(output_path, 'w', newline='') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=fields)
            writer.writeheader()
            writer.writerows(data)
            
        logger.info(f"Successfully wrote {len(data)} rows to {output_path}")
        return True
    except Exception as e:
        logger.error(f"Error writing CSV to {output_path}: {str(e)}")
        return False

def validate_and_clean_data(data):
    """Validate and clean data, filling missing values with 'review'"""
    if not data:
        return []
    
    cleaned_data = []
    standard_fields = ['id', 'name', 'category', 'size', 'status', 'price', 'location', 'condition', 'notes']
    
    # Create mapping of actual fields to standard fields
    field_mapping = {}
    for std_field in standard_fields:
        for actual_field in data[0].keys():
            if std_field in actual_field.lower():
                field_mapping[std_field] = actual_field
                break
    
    # Clean each item
    for idx, item in enumerate(data):
        clean_item = {}
        
        # Map known fields
        for std_field in standard_fields:
            if std_field in field_mapping and field_mapping[std_field] in item:
                clean_item[std_field] = item[field_mapping[std_field]]
            else:
                clean_item[std_field] = "review"
        
        # Generate ID if missing
        if clean_item['id'] == "review" and clean_item['name'] != "review":
            # Create ID from name
            name = clean_item['name']
            name_prefix = ''.join(c for c in name.lower() if c.isalnum())[:5]
            clean_item['id'] = f"{name_prefix}{idx:03d}"
        
        # Ensure status is valid
        valid_statuses = ['Available', 'In Use', 'Cleaning', 'In Repair']
        if clean_item['status'] == "review" or clean_item['status'] not in valid_statuses:
            clean_item['status'] = 'Available'
        
        cleaned_data.append(clean_item)
    
    return cleaned_data

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
        
        try:
            # Extract text from PDF
            text_content = extract_text_from_pdf(pdf_path)
            
            if text_content:
                # Parse into structured data
                parsed_data = parse_text_into_data(text_content)
                
                if parsed_data:
                    # Clean and validate
                    clean_data = validate_and_clean_data(parsed_data)
                    
                    # Save to CSV
                    if save_to_csv(clean_data, csv_path):
                        processed += 1
                    else:
                        failed += 1
                else:
                    logger.warning(f"Failed to parse content from {pdf_file}")
                    failed += 1
            else:
                logger.warning(f"Failed to extract text from {pdf_file}")
                failed += 1
        except Exception as e:
            logger.error(f"Error processing {pdf_file}: {str(e)}")
            logger.debug(traceback.format_exc())
            failed += 1
    
    logger.info(f"Processed {processed} files successfully, {failed} files failed")

if __name__ == "__main__":
    logger.info("Starting PDF to CSV conversion")
    process_pdf_files()
    logger.info("Conversion process complete")
