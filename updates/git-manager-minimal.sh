#!/bin/bash
# Git manager for Costume Scheduler project

# Set colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Base directory
BASE_DIR=$(git rev-parse --show-toplevel 2>/dev/null)
VERSION_FILE="$BASE_DIR/version.json"

# Main menu function
function main_menu() {
    clear
    echo "Costume Scheduler Git Manager"
    echo "--------------------------"
    echo "1. Branch Management"
    echo "2. Version Tagging"
    echo "3. Conflict Resolution"
    echo "4. Gitignore Management"
    echo "5. File Management"
    echo "6. Exit"
    echo

    read -p "Select an option: " choice
    case $choice in
        1) branch_menu ;;
        2) version_menu ;;
        3) conflict_menu ;;
        4) gitignore_menu ;;
        5) file_menu ;;
        6) exit 0 ;;
        *) echo "Invalid option"; sleep 1; main_menu ;;
    esac
}

# Branch management menu
function branch_menu() {
    clear
    echo "Branch Management"
    echo "-----------------"
    echo "1. Create new branch"
    echo "2. List all branches"
    echo "3. Switch branch"
    echo "4. Merge branch"
    echo "5. Delete branch"
    echo "6. Back to main menu"
    echo

    read -p "Select an option: " choice
    case $choice in
        1) 
            read -p "Branch name: " branch_name
            read -p "Base branch (default: current): " base_branch
            base_branch=${base_branch:-$(git branch --show-current)}
            git checkout $base_branch && git checkout -b $branch_name
            read -p "Press Enter to continue..." 
            branch_menu
            ;;
        2)
            echo "Current branch: $(git branch --show-current)"
            echo "All branches:"
            git branch -a
            read -p "Press Enter to continue..." 
            branch_menu
            ;;
        3)
            read -p "Branch name: " branch_name
            git checkout $branch_name
            read -p "Press Enter to continue..." 
            branch_menu
            ;;
        4)
            read -p "Source branch: " source_branch
            read -p "Target branch (default: current): " target_branch
            target_branch=${target_branch:-$(git branch --show-current)}
            git checkout $target_branch && git merge $source_branch
            read -p "Press Enter to continue..." 
            branch_menu
            ;;
        5)
            read -p "Branch name: " branch_name
            git branch -d $branch_name
            read -p "Press Enter to continue..." 
            branch_menu
            ;;
        6) main_menu ;;
        *) echo "Invalid option"; sleep 1; branch_menu ;;
    esac
}

# Version tagging menu
function version_menu() {
    clear
    echo "Version Tagging"
    echo "--------------"
    echo "1. Create tag from version.json"
    echo "2. Increment version (major/minor/patch)"
    echo "3. List tags"
    echo "4. Back to main menu"
    echo

    read -p "Select an option: " choice
    case $choice in
        1)
            read -p "Tag message: " message
            # Extract version from version.json
            frontend_version=$(grep -o '"frontend": *"[^"]*"' "$VERSION_FILE" | grep -o '"[^"]*"$' | tr -d '"')
            git tag -a "$frontend_version" -m "$message" && git push origin "$frontend_version"
            read -p "Press Enter to continue..." 
            version_menu
            ;;
        2)
            read -p "Type (major/minor/patch): " type
            read -p "Tag message: " message
            
            # Get current version
            version=$(grep -o '"frontend": *"[^"]*"' "$VERSION_FILE" | grep -o '"[^"]*"$' | tr -d '"')
            version=${version#v}
            IFS='.' read -r -a version_parts <<< "$version"
            
            case $type in
                major) 
                    new_version="v$((${version_parts[0]}+1)).0.0" 
                    ;;
                minor) 
                    new_version="v${version_parts[0]}.$((${version_parts[1]}+1)).0" 
                    ;;
                patch) 
                    new_version="v${version_parts[0]}.${version_parts[1]}.$((${version_parts[2]}+1))" 
                    ;;
            esac
            
            # Update version.json
            sed -i.bak "s/\"frontend\": *\"[^\"]*\"/\"frontend\": \"$new_version\"/" "$VERSION_FILE"
            sed -i.bak "s/\"backend\": *\"[^\"]*\"/\"backend\": \"$new_version\"/" "$VERSION_FILE"
            rm -f "$VERSION_FILE.bak"
            
            # Commit and tag
            git add "$VERSION_FILE"
            git commit -m "Update version to $new_version"
            git tag -a "$new_version" -m "$message"
            read -p "Press Enter to continue..." 
            version_menu
            ;;
        3)
            git tag -l --sort=-v:refname | head -n 10
            read -p "Press Enter to continue..." 
            version_menu
            ;;
        4) main_menu ;;
        *) echo "Invalid option"; sleep 1; version_menu ;;
    esac
}

# Conflict resolution menu
function conflict_menu() {
    clear
    echo "Conflict Resolution"
    echo "------------------"
    echo "1. Check for conflicts"
    echo "2. Resolve conflicts (ours)"
    echo "3. Resolve conflicts (theirs)"
    echo "4. Abort merge"
    echo "5. Back to main menu"
    echo

    read -p "Select an option: " choice
    case $choice in
        1)
            # Check for conflicts
            if git diff --name-only --diff-filter=U | grep -q .; then
                echo "Conflicts detected in:"
                git diff --name-only --diff-filter=U
            else
                echo "No conflicts detected"
            fi
            read -p "Press Enter to continue..." 
            conflict_menu
            ;;
        2)
            # Resolve using 'ours'
            git diff --name-only --diff-filter=U | xargs -I{} git checkout --ours {} 2>/dev/null
            git diff --name-only --diff-filter=U | xargs -I{} git add {} 2>/dev/null
            echo "Conflicts resolved using 'ours' strategy"
            read -p "Press Enter to continue..." 
            conflict_menu
            ;;
        3)
            # Resolve using 'theirs'
            git diff --name-only --diff-filter=U | xargs -I{} git checkout --theirs {} 2>/dev/null
            git diff --name-only --diff-filter=U | xargs -I{} git add {} 2>/dev/null
            echo "Conflicts resolved using 'theirs' strategy"
            read -p "Press Enter to continue..." 
            conflict_menu
            ;;
        4)
            git merge --abort
            echo "Merge aborted"
            read -p "Press Enter to continue..." 
            conflict_menu
            ;;
        5) main_menu ;;
        *) echo "Invalid option"; sleep 1; conflict_menu ;;
    esac
}

# Gitignore management menu
function gitignore_menu() {
    clear
    echo "Gitignore Management"
    echo "-------------------"
    echo "1. Add pattern"
    echo "2. Remove pattern"
    echo "3. List gitignore"
    echo "4. Edit gitignore"
    echo "5. Back to main menu"
    echo

    read -p "Select an option: " choice
    case $choice in
        1)
            read -p "Pattern to add: " pattern
            echo "$pattern" >> .gitignore
            git add .gitignore
            echo "Pattern added to .gitignore"
            read -p "Press Enter to continue..." 
            gitignore_menu
            ;;
        2)
            read -p "Pattern to remove: " pattern
            sed -i.bak "/^$pattern$/d" .gitignore
            rm -f .gitignore.bak
            git add .gitignore
            echo "Pattern removed from .gitignore"
            read -p "Press Enter to continue..." 
            gitignore_menu
            ;;
        3)
            if [ -f .gitignore ]; then
                echo "Contents of .gitignore:"
                cat .gitignore
            else
                echo ".gitignore file doesn't exist"
            fi
            read -p "Press Enter to continue..." 
            gitignore_menu
            ;;
        4)
            ${EDITOR:-vi} .gitignore
            git add .gitignore
            echo "Gitignore updated"
            read -p "Press Enter to continue..." 
            gitignore_menu
            ;;
        5) main_menu ;;
        *) echo "Invalid option"; sleep 1; gitignore_menu ;;
    esac
}

# File management menu
function file_menu() {
    clear
    echo "File Management"
    echo "--------------"
    echo "1. Remove file from repo (keep local)"
    echo "2. Restore file from previous commit"
    echo "3. Back to main menu"
    echo

    read -p "Select an option: " choice
    case $choice in
        1)
            read -p "File path: " file_path
            git rm --cached "$file_path"
            echo "File removed from repo (kept locally)"
            read -p "Press Enter to continue..." 
            file_menu
            ;;
        2)
            read -p "File path: " file_path
            read -p "Commit hash (default: HEAD~1): " commit
            commit=${commit:-HEAD~1}
            git checkout $commit -- "$file_path"
            echo "File restored from $commit"
            read -p "Press Enter to continue..." 
            file_menu
            ;;
        3) main_menu ;;
        *) echo "Invalid option"; sleep 1; file_menu ;;
    esac
}

# Start the menu
main_menu
