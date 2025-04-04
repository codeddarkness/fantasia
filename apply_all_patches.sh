#!/bin/bash

# Set colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Costume Scheduler UI & Functionality Fixes ====${NC}"
echo ""

# Create necessary directories
echo -e "${BLUE}Creating necessary directories...${NC}"
mkdir -p frontend/templates/feature
echo -e "${GREEN}✓ Created feature directory${NC}"
echo ""

# Apply the dashboard fix
echo -e "${BLUE}Applying dashboard layout fix...${NC}"
if [ -f "frontend/templates/dashboard_new.html" ]; then
  echo -e "${GREEN}✓ Dashboard template already exists${NC}"
else
  if [ -f "updates/dashboard_new.html" ]; then
    cp -f updates/dashboard_new.html frontend/templates/
    echo -e "${GREEN}✓ Installed dashboard from updates directory${NC}"
  else
    echo -e "${YELLOW}⚠ dashboard_new.html not found in updates directory${NC}"
  fi
fi
echo ""

# Apply the Gantt chart fix
echo -e "${BLUE}Applying Gantt Chart fix...${NC}"
if [ -f "frontend/templates/feature/gantt.html" ]; then
  echo -e "${GREEN}✓ Gantt template already exists${NC}"
else
  if [ -f "updates/gantt.html" ]; then
    cp -f updates/gantt.html frontend/templates/feature/
    echo -e "${GREEN}✓ Installed Gantt Chart from updates directory${NC}"
  else
    echo -e "${YELLOW}⚠ gantt.html not found in updates directory${NC}"
  fi
fi
echo ""

# Apply the inventory editor fix
echo -e "${BLUE}Applying inventory editor fix...${NC}"
if [ -f "frontend/templates/feature/wardrobe_editor.html" ]; then
  echo -e "${GREEN}✓ Inventory editor template already exists${NC}"
else
  if [ -f "updates/wardrobe_editor.html" ]; then
    cp -f updates/wardrobe_editor.html frontend/templates/feature/
    echo -e "${GREEN}✓ Installed inventory editor from updates directory${NC}"
  else
    echo -e "${YELLOW}⚠ wardrobe_editor.html not found in updates directory${NC}"
    echo -e "${YELLOW}Creating a basic inventory editor...${NC}"
    touch frontend/templates/feature/wardrobe_editor.html
  fi
fi
echo ""

# Apply the responsive menu fix
echo -e "${BLUE}Applying responsive menu fix...${NC}"
mkdir -p frontend/static/js/utils
cat > frontend/static/js/utils/responsive-menu.js << 'ENDMENU'
// Responsive Menu Detection with iframe protection
(function() {
  function detectIframe() {
    // Check if we're in an iframe
    if (window.self !== window.top) {
      console.log("Detected running in iframe - hiding navigation");
      
      // Hide all navigation elements
      const navElements = document.querySelectorAll('.nav-menu, .main-nav, nav, header');
      navElements.forEach(el => {
        if (el) el.style.display = 'none';
      });
      
      // Add padding to body to compensate for removed nav
      document.body.style.paddingTop = '0';
      
      // Add class to body for iframe-specific styling
      document.body.classList.add('in-iframe');
    } else {
      console.log("Running as main window - showing navigation");
    }
  }
  
  // Run on load
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', detectIframe);
  } else {
    detectIframe();
  }
})();
ENDMENU
echo -e "${GREEN}✓ Created responsive menu utility${NC}"
echo ""

# Apply the PDF converter
echo -e "${BLUE}Applying PDF to CSV converter...${NC}"
if [ -f "pdf_to_csv.py" ]; then
  echo -e "${GREEN}✓ PDF converter already exists${NC}"
else
  if [ -f "updates/pdf_to_csv.py" ]; then
    cp -f updates/pdf_to_csv.py ./
    chmod +x pdf_to_csv.py
    echo -e "${GREEN}✓ Installed PDF converter from updates directory${NC}"
  else
    echo -e "${YELLOW}⚠ pdf_to_csv.py not found in updates directory${NC}"
  fi
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
