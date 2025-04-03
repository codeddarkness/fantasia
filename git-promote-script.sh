#!/bin/bash
# Git Promotion Script - Promotes core changes to main branch

# Set colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Variables
CURRENT_BRANCH=$(git branch --show-current)
TARGET_BRANCH="main"
COMMIT_MESSAGE="Updated interface with unified navigation and improved dashboard"
VERSION="v0.5.0"

echo -e "${BLUE}=== Costume Scheduler Git Promotion Tool ===${NC}"
echo -e "${BLUE}This script will promote core changes to the main branch${NC}"
echo -e "${BLUE}Current branch: ${YELLOW}$CURRENT_BRANCH${NC}"
echo -e "${BLUE}Target branch: ${YELLOW}$TARGET_BRANCH${NC}"
echo ""

# Verify we're on the dev branch
if [[ "$CURRENT_BRANCH" != "dev/menu_overhaul" ]]; then
    echo -e "${YELLOW}Warning: You are not on the dev/menu_overhaul branch${NC}"
    read -p "Continue anyway? (y/n): " confirm
    if [[ "$confirm" != "y" ]]; then
        echo -e "${RED}Promotion canceled${NC}"
        exit 1
    fi
fi

# Check for uncommitted changes
if [[ -n "$(git status --porcelain)" ]]; then
    echo -e "${YELLOW}Warning: You have uncommitted changes${NC}"
    git status --short
    echo ""
    read -p "Would you like to commit these changes first? (y/n): " commit_changes
    if [[ "$commit_changes" == "y" ]]; then
        read -p "Enter commit message: " user_message
        git add .
        git commit -m "$user_message"
        echo -e "${GREEN}Changes committed${NC}"
    else
        echo -e "${YELLOW}Proceeding with uncommitted changes. They will not be included in the promotion.${NC}"
    fi
fi

# Create a temporary branch for the promotion
echo -e "${BLUE}Creating temporary branch for promotion...${NC}"
TEMP_BRANCH="temp-promotion-$(date +%Y%m%d%H%M%S)"
git checkout -b $TEMP_BRANCH

# Check if temporary branch creation was successful
if [[ $? -ne 0 ]]; then
    echo -e "${RED}Failed to create temporary branch${NC}"
    exit 1
fi

# Update version.json
echo -e "${BLUE}Updating version information...${NC}"
echo "{
  \"backend\": \"$VERSION\",
  \"frontend\": \"$VERSION\"
}" > version.json
echo -e "${GREEN}✓ Updated version.json to $VERSION${NC}"

# Stage the core files
echo -e "${BLUE}Staging core files for promotion...${NC}"

# Core files list
CORE_FILES=(
    "backend/app.py"
    "frontend/templates/dashboard_new.html" 
    "frontend/templates/feature/gantt.html"
    "frontend/templates/feature/extended_overlap.html"
    "frontend/templates/feature/wardrobe_editor.html"
    "frontend/templates/feature/reports.html"
    "version.json"
    "check_frontend.sh"
    "check_frontend_enhanced.sh"
    "README.md"
    "changelog.md"
)

# Stage each file
for file in "${CORE_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        git add "$file"
        echo -e "${GREEN}✓ Staged: $file${NC}"
    else
        echo -e "${YELLOW}Warning: File not found: $file${NC}"
    fi
done

# Commit the changes
echo -e "${BLUE}Committing changes...${NC}"
git commit -m "$COMMIT_MESSAGE"

if [[ $? -ne 0 ]]; then
    echo -e "${RED}Failed to commit changes${NC}"
    echo -e "${YELLOW}Returning to original branch...${NC}"
    git checkout $CURRENT_BRANCH
    git branch -D $TEMP_BRANCH
    exit 1
fi

# Switch to main branch
echo -e "${BLUE}Switching to $TARGET_BRANCH branch...${NC}"
git checkout $TARGET_BRANCH

if [[ $? -ne 0 ]]; then
    echo -e "${RED}Failed to switch to $TARGET_BRANCH branch${NC}"
    echo -e "${YELLOW}Returning to original branch...${NC}"
    git checkout $CURRENT_BRANCH
    git branch -D $TEMP_BRANCH
    exit 1
fi

# Merge the temporary branch
echo -e "${BLUE}Merging changes into $TARGET_BRANCH...${NC}"
git merge --no-ff $TEMP_BRANCH -m "Merge $TEMP_BRANCH: $COMMIT_MESSAGE"

if [[ $? -ne 0 ]]; then
    echo -e "${RED}Merge conflict detected${NC}"
    echo -e "${YELLOW}Please resolve the conflicts manually and then run:${NC}"
    echo "  git add <resolved-files>"
    echo "  git commit -m \"Resolved conflicts: $COMMIT_MESSAGE\""
    echo "  git tag $VERSION -m \"Release $VERSION\""
    echo "  git branch -d $TEMP_BRANCH"
    exit 1
fi

# Tag the release
echo -e "${BLUE}Tagging release as $VERSION...${NC}"
git tag $VERSION -m "Release $VERSION: $COMMIT_MESSAGE"

# Clean up temporary branch
echo -e "${BLUE}Cleaning up temporary branch...${NC}"
git branch -d $TEMP_BRANCH

# Return to the original branch
echo -e "${BLUE}Returning to $CURRENT_BRANCH branch...${NC}"
git checkout $CURRENT_BRANCH

# Show success message
echo -e "${GREEN}=== Promotion Complete ===${NC}"
echo -e "${GREEN}Changes have been successfully promoted to the $TARGET_BRANCH branch and tagged as $VERSION${NC}"
echo ""
echo -e "${BLUE}To push changes to remote repository:${NC}"
echo "  git push origin $TARGET_BRANCH"
echo "  git push origin $VERSION"
echo ""
