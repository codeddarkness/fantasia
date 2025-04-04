cat > README.md << 'EOF'
# Inventory Data Extractor

## Overview

A flexible tool for extracting inventory data from various file formats, including:
- PDF files
- Excel spreadsheets (.xlsx, .xls)
- OpenDocument Spreadsheets (.ods)
- CSV files

## Version
v1.0.1

## Changelog
- v1.0.1: Added intelligent duplicate file detection and processing
- v0.4.0: Removed Java/Tabula dependency, switched to PyMuPDF for PDF text extraction
- v0.3.0: Added support for Excel, ODS, and CSV formats
- v0.2.0: Improved directory handling with automatic input/output detection
- v0.1.0: Enhanced PDF text extraction and data processing
- v0.0.1: Initial release with basic PDF processing capabilities

## Key Features
- Extract inventory data from multiple file formats
- Intelligent duplicate file detection (avoids processing the same data twice)
- Format priority system (prefers structured formats like Excel over PDF)
- Automatic categorization of inventory items
- Size normalization
- Flexible column mapping

## Prerequisites

- Python 3.7+
- pip (Python package manager)

## Installation

Clone the repository and install dependencies:

    pip install pandas PyMuPDF openpyxl odfpy

## Usage

### Basic Usage

    python inventory_data_extractor.py

- Automatically detects input directories:
  - PDF files: `../pdf_imports` → `../pdf_conversions`
  - Excel/ODS files: `../sheets` → `../sheets_conversions`

### Command Line Options

    # Specify input directory
    python inventory_data_extractor.py -i /path/to/input/files

    # Specify output directory
    python inventory_data_extractor.py -o /path/to/output/files

    # Enable verbose logging
    python inventory_data_extractor.py -v

    # Process all files even if duplicates exist
    python inventory_data_extractor.py --force

    # Clean output directories before processing
    python inventory_data_extractor.py --clean

## Duplicate File Handling
The tool intelligently identifies and skips duplicate files:
- It normalizes filenames to detect duplicates with different extensions
- Processes files based on a priority system (Excel > CSV > PDF)
- Only creates one JSON output per unique inventory dataset
- Can be overridden with the `--force` option

## Supported Input Formats
- PDF
- .xlsx (Excel)
- .xls (Excel)
- .ods (OpenDocument Spreadsheet)
- .csv

## Output Format
Generated JSON follows this structure:

    {
      "version": "v1.0.1",
      "wardrobe_items": [
        {
          "id": "item_unique_id",
          "name": "Inventory Item",
          "size": "M",
          "status": "Available",
          "category": "Item Category",
          "price": null,
          "location": null,
          "condition": "Unknown",
          "notes": null
        }
      ],
      "categories": [
        {
          "id": "category_id",
          "name": "Category Name",
          "description": "Category description"
        }
      ]
    }

## Data Normalization
- Sizes are standardized (S, M, L, XL, numeric sizes)
- Categories are automatically detected
- Unique IDs generated for each item

## Troubleshooting
- Ensure input files have readable data
- Check file permissions
- Use verbose mode (`-v`) for detailed logging

## Common Issues
### PDF Extraction
- Text extraction may not be perfect for complex PDFs
- Manual review of extracted data is recommended

### Excel/CSV Handling
- Ensure consistent column naming across files
- Remove any merged cells or complex formatting

### Duplicate Detection
- If files with different names contain the same data, they may not be detected as duplicates
- The `--clean` option can be used to start fresh if needed

## Contributing
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License
[Specify your license here]

## Contact
For any questions or issues, please open a GitHub issue in the repository.
EOF
