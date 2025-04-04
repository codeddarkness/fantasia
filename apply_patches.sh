#!/bin/bash
# Apply UI and functionality fixes to Costume Scheduler

# Set colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Costume Scheduler UI & Functionality Fixes ===${NC}"
echo ""

# Create necessary directories
echo -e "${BLUE}Creating necessary directories...${NC}"
mkdir -p frontend/templates/feature
echo -e "${GREEN}✓ Created feature directory${NC}"
echo ""

# Apply fixes for menu recursion in inventory editor
echo -e "${BLUE}Applying navigation menu fix to inventory editor...${NC}"
if [ -f "updates/wardrobe_editor.html" ]; then
  cp -f updates/wardrobe_editor.html frontend/templates/feature/
  echo -e "${GREEN}✓ Fixed inventory editor navigation${NC}"
else
  echo -e "${YELLOW}⚠ wardrobe_editor.html not found in updates directory${NC}"
fi
echo ""

# Apply enhanced Gantt Chart with form controls
echo -e "${BLUE}Applying enhanced Gantt Chart with assignment form...${NC}"
if [ -f "updates/gantt.html" ]; then
  cp -f updates/gantt.html frontend/templates/feature/
  echo -e "${GREEN}✓ Updated Gantt Chart with enhanced form${NC}"
else
  echo -e "${YELLOW}⚠ gantt.html not found in updates directory${NC}"
fi
echo ""

# Apply dashboard layout fixes
echo -e "${BLUE}Applying dashboard layout fixes...${NC}"
if [ -f "updates/dashboard_new.html" ]; then
  cp -f updates/dashboard_new.html frontend/templates/
  echo -e "${GREEN}✓ Fixed dashboard layout and menu${NC}"
else
  echo -e "${YELLOW}⚠ dashboard_new.html not found in updates directory${NC}"
fi
echo ""

# Apply PDF converter with validation
echo -e "${BLUE}Installing improved PDF to CSV converter...${NC}"
if [ -f "updates/pdf_to_csv.py" ]; then
  cp -f updates/pdf_to_csv.py ./
  chmod +x pdf_to_csv.py
  echo -e "${GREEN}✓ Installed improved PDF converter with validation${NC}"
else
  echo -e "${YELLOW}⚠ pdf_to_csv.py not found in updates directory${NC}"
fi
echo ""

# Update version.json
echo -e "${BLUE}Updating version information...${NC}"
echo '{
  "backend": "v0.5.0",
  "frontend": "v0.5.0"
}' > version.json
echo -e "${GREEN}✓ Updated version to v0.5.0${NC}"
echo ""

echo -e "${GREEN}Patch application complete!${NC}"
echo -e "${BLUE}Please restart the application to see the changes.${NC}"
