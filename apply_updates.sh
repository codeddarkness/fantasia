#!/bin/bash
# Apply Updates Script for Costume Scheduler
# This script installs all updates from the updates/ directory

# Set colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Base directory
BASE_DIR=$(pwd)
UPDATES_DIR="$BASE_DIR/updates"
VERSION="v0.5.0"

echo -e "${BLUE}=== Costume Scheduler Update Installer ===${NC}"
echo -e "${BLUE}Installing updates from $UPDATES_DIR to $BASE_DIR${NC}"
echo -e "${BLUE}Target version: $VERSION${NC}"
echo ""

# Check if updates directory exists
if [ ! -d "$UPDATES_DIR" ]; then
    echo -e "${RED}Error: Updates directory not found at $UPDATES_DIR${NC}"
    exit 1
fi

# Create necessary directories
echo -e "${BLUE}Creating necessary directories...${NC}"
mkdir -p "$BASE_DIR/frontend/templates/feature"
mkdir -p "$BASE_DIR/pdf_imports"
mkdir -p "$BASE_DIR/pdf_conversions"
echo -e "${GREEN}Directories created successfully${NC}"
echo ""

# Update backend files
echo -e "${BLUE}Updating backend files...${NC}"
if [ -f "$UPDATES_DIR/updated-app-py.py" ]; then
    cp "$UPDATES_DIR/updated-app-py.py" "$BASE_DIR/backend/app.py"
    echo -e "${GREEN}✓ Updated app.py${NC}"
else
    echo -e "${YELLOW}⚠ app.py update file not found${NC}"
fi

# Install PDF converter
if [ -f "$UPDATES_DIR/pdf-to-csv-converter.py" ]; then
    cp "$UPDATES_DIR/pdf-to-csv-converter.py" "$BASE_DIR/pdf_to_csv.py"
    chmod +x "$BASE_DIR/pdf_to_csv.py"
    echo -e "${GREEN}✓ Installed PDF to CSV converter${NC}"
else
    echo -e "${YELLOW}⚠ PDF converter file not found${NC}"
fi

# Install Git Manager
if [ -f "$UPDATES_DIR/git-manager-minimal.sh" ]; then
    cp "$UPDATES_DIR/git-manager-minimal.sh" "$BASE_DIR/git-manager.sh"
    chmod +x "$BASE_DIR/git-manager.sh"
    echo -e "${GREEN}✓ Installed Git Manager${NC}"
else
    echo -e "${YELLOW}⚠ Git Manager file not found${NC}"
fi
echo ""

# Update templates
echo -e "${BLUE}Updating templates...${NC}"
if [ -f "$UPDATES_DIR/reports-page.html" ]; then
    cp "$UPDATES_DIR/reports-page.html" "$BASE_DIR/frontend/templates/feature/reports.html"
    echo -e "${GREEN}✓ Installed reports page${NC}"
else
    echo -e "${YELLOW}⚠ Reports page file not found${NC}"
fi

if [ -f "$UPDATES_DIR/updated-extended-view-complete.html" ]; then
    cp "$UPDATES_DIR/updated-extended-view-complete.html" "$BASE_DIR/frontend/templates/feature/extended_overlap.html"
    echo -e "${GREEN}✓ Installed extended view${NC}"
else
    echo -e "${YELLOW}⚠ Extended view file not found${NC}"
fi

if [ -f "$UPDATES_DIR/experimental-dashboard-complete.html" ]; then
    cp "$UPDATES_DIR/experimental-dashboard-complete.html" "$BASE_DIR/frontend/templates/test/experimental_dashboard.html"
    echo -e "${GREEN}✓ Installed experimental dashboard${NC}"
else
    echo -e "${YELLOW}⚠ Experimental dashboard file not found${NC}"
fi

# Copy existing templates to feature directory
echo -e "${BLUE}Copying existing templates to feature directory...${NC}"
if [ -f "$BASE_DIR/frontend/templates/test/gantt.html" ]; then
    cp "$BASE_DIR/frontend/templates/test/gantt.html" "$BASE_DIR/frontend/templates/feature/"
    echo -e "${GREEN}✓ Copied gantt.html${NC}"
else
    echo -e "${YELLOW}⚠ gantt.html not found${NC}"
fi

if [ -f "$BASE_DIR/frontend/templates/test/wardrobe_editor.html" ]; then
    cp "$BASE_DIR/frontend/templates/test/wardrobe_editor.html" "$BASE_DIR/frontend/templates/feature/"
    echo -e "${GREEN}✓ Copied wardrobe_editor.html${NC}"
else
    echo -e "${YELLOW}⚠ wardrobe_editor.html not found${NC}"
fi
echo ""

# Update documentation
echo -e "${BLUE}Updating documentation...${NC}"
if [ -f "$UPDATES_DIR/completed-changelog.txt" ]; then
    cp "$UPDATES_DIR/completed-changelog.txt" "$BASE_DIR/changelog.md"
    echo -e "${GREEN}✓ Updated changelog.md${NC}"
else
    echo -e "${YELLOW}⚠ Updated changelog file not found${NC}"
fi

if [ -f "$UPDATES_DIR/updated-readme.txt" ]; then
    cp "$UPDATES_DIR/updated-readme.txt" "$BASE_DIR/README.md"
    echo -e "${GREEN}✓ Updated README.md${NC}"
else
    echo -e "${YELLOW}⚠ Updated README file not found${NC}"
fi
echo ""

# Update version.json
echo -e "${BLUE}Updating version.json...${NC}"
if [ -f "$BASE_DIR/version.json" ]; then
    echo "{
  \"backend\": \"$VERSION\",
  \"frontend\": \"$VERSION\"
}" > "$BASE_DIR/version.json"
    echo -e "${GREEN}✓ Updated version.json to $VERSION${NC}"
else
    echo -e "${YELLOW}⚠ version.json not found${NC}"
fi
echo ""

echo -e "${GREEN}=== Update Installation Complete ===${NC}"
echo -e "${BLUE}Version $VERSION has been installed.${NC}"
echo -e "${BLUE}Please restart the application using:${NC}"
echo "python backend/app.py"
echo ""
echo -e "${YELLOW}Note: If the application is currently running, you may need to stop it first.${NC}"
