#!/bin/bash
# Corrected Patcher Script for Costume Scheduler v0.5.0
# This script applies all the corrected updates and fixes

# Set colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Version info
VERSION="v0.5.0"
PATCH_DATE=$(date +"%Y-%m-%d")

echo -e "${BLUE}=== Costume Scheduler v0.5.0 Patcher ===${NC}"
echo -e "${BLUE}Date: $PATCH_DATE${NC}"
echo ""

# Create backup of current version
echo -e "${YELLOW}Creating backup of current version...${NC}"
BACKUP_DIR="backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp -r backend "$BACKUP_DIR/"
cp -r frontend "$BACKUP_DIR/"
cp -r *.json "$BACKUP_DIR/" 2>/dev/null
cp -r *.md "$BACKUP_DIR/" 2>/dev/null
cp -r *.sh "$BACKUP_DIR/" 2>/dev/null
echo -e "${GREEN}Backup created in $BACKUP_DIR${NC}"
echo ""

# Create necessary directories
echo -e "${BLUE}Creating necessary directories...${NC}"
mkdir -p frontend/templates/feature
echo -e "${GREEN}Directory structure prepared${NC}"
echo ""

# Update app.py with corrected routes
echo -e "${BLUE}Updating backend/app.py with corrected routes...${NC}"
if [ -f "corrected-app-py.py" ]; then
    cp corrected-app-py.py backend/app.py
    echo -e "${GREEN}✓ Updated app.py${NC}"
else
    echo -e "${RED}Error: corrected-app-py.py not found${NC}"
    echo -e "${YELLOW}Please ensure the corrected app.py file is in the current directory${NC}"
    exit 1
fi

# Create feature directory templates
echo -e "${BLUE}Setting up feature directory templates...${NC}"

# Copy Gantt Chart template
if [ -f "updated-gantt-template.html" ]; then
    cp updated-gantt-template.html frontend/templates/feature/gantt.html
    echo -e "${GREEN}✓ Installed updated Gantt Chart template${NC}"
else
    echo -e "${RED}Error: updated-gantt-template.html not found${NC}"
fi

# Copy Extended View template
if [ -f "updated-extended-view-complete.html" ]; then
    cp updated-extended-view-complete.html frontend/templates/feature/extended_overlap.html
    echo -e "${GREEN}✓ Installed updated Extended View template${NC}"
else
    echo -e "${RED}Error: updated-extended-view-complete.html not found${NC}"
fi

# Copy Wardrobe Editor template (from test directory if exists)
if [ -f "frontend/templates/test/wardrobe_editor.html" ]; then
    cp frontend/templates/test/wardrobe_editor.html frontend/templates/feature/
    echo -e "${GREEN}✓ Copied Wardrobe Editor template to feature directory${NC}"
else
    echo -e "${YELLOW}⚠ Test Wardrobe Editor template not found${NC}"
fi

# Copy Reports template
if [ -f "reports-page.html" ]; then
    cp reports-page.html frontend/templates/feature/reports.html
    echo -e "${GREEN}✓ Installed Reports template${NC}"
else
    echo -e "${RED}Error: reports-page.html not found${NC}"
fi

# Update experimental dashboard
if [ -f "completed-experimental-dashboard.html" ]; then
    cp completed-experimental-dashboard.html frontend/templates/test/experimental_dashboard.html
    echo -e "${GREEN}✓ Installed updated Experimental Dashboard${NC}"
else
    echo -e "${RED}Error: completed-experimental-dashboard.html not found${NC}"
fi
echo ""

# Update check script
echo -e "${BLUE}Updating frontend check script...${NC}"
if [ -f "updated-check-frontend.sh" ]; then
    cp updated-check-frontend.sh check_frontend_enhanced.sh
    chmod +x check_frontend_enhanced.sh
    echo -e "${GREEN}✓ Updated check_frontend_enhanced.sh${NC}"
else
    echo -e "${RED}Error: updated-check-frontend.sh not found${NC}"
fi
echo ""

# Update version.json
echo -e "${BLUE}Updating version information...${NC}"
echo "{
  \"backend\": \"$VERSION\",
  \"frontend\": \"$VERSION\"
}" > version.json
echo -e "${GREEN}✓ Updated version.json to $VERSION${NC}"
echo ""

# Final wrap-up
echo -e "${GREEN}=== Patch Complete ===${NC}"
echo -e "${BLUE}Costume Scheduler has been updated to $VERSION${NC}"
echo -e "${BLUE}Next steps:${NC}"
echo "1. Run ./check_frontend_enhanced.sh to verify all routes"
echo "2. Start the application with: python backend/app.py"
echo ""
echo -e "${YELLOW}Note: If the application is currently running, you need to restart it${NC}"
