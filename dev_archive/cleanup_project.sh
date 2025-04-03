#!/bin/bash
set -e

echo "🧹 Cleaning up Costume Scheduler project..."

# Create backup of current state
mkdir -p backup_$(date +%Y%m%d)
cp -r backend frontend data version.json backup_$(date +%Y%m%d)/

# Simplify patching system
echo "📦 Simplifying patch system..."
mkdir -p .simplified

# Remove old patch scripts
find . -name "apply_patch_v*.sh" -exec rm {} \;

# Create simplified patch tool
cat << 'EOF' > patch_manager.sh
#!/bin/bash
set -e

function show_help() {
  echo "Usage: ./patch_manager.sh [command]"
  echo "Commands:"
  echo "  apply [version]  - Apply a specific patch version"
  echo "  create [files]   - Create a new patch with specified files"
  echo "  list             - Show available patches"
  echo "  clean            - Remove old/unused patches"
}

function apply_patch() {
  VERSION=$1
  PATCH_DIR="patches/$VERSION"
  
  if [ ! -d "$PATCH_DIR" ]; then
    echo "❌ Patch $VERSION not found"
    exit 1
  fi
  
  # Copy backend files
  if [ -d "$PATCH_DIR/backend" ]; then
    for file in $(find "$PATCH_DIR/backend" -type f); do
      target=${file#"$PATCH_DIR/"}
      mkdir -p $(dirname "$target")
      cp "$file" "$target"
      echo "✅ Applied: $target"
    done
  fi
  
  # Copy frontend files
  if [ -d "$PATCH_DIR/frontend" ]; then
    for file in $(find "$PATCH_DIR/frontend" -type f); do
      target=${file#"$PATCH_DIR/"}
      mkdir -p $(dirname "$target")
      cp "$file" "$target"
      echo "✅ Applied: $target"
    done
  fi
  
  # Update version
  if command -v jq &>/dev/null; then
    jq ".frontend = \"$VERSION\" | .backend = \"$VERSION\"" version.json > version.tmp && mv version.tmp version.json
    echo "📝 Updated version to $VERSION"
  else
    echo "⚠️ jq not installed, version.json not updated"
  fi
  
  echo "🎉 Patch $VERSION applied successfully"
}

function list_patches() {
  echo "Available patches:"
  find patches -maxdepth 1 -type d | grep -v "^patches$" | sort -V | sed 's|patches/|  |'
}

function create_patch() {
  VERSION="v$(date +%Y.%m.%d)"
  PATCH_DIR="patches/$VERSION"
  
  mkdir -p "$PATCH_DIR"
  
  for file in "$@"; do
    if [ -f "$file" ]; then
      target="$PATCH_DIR/$file"
      mkdir -p $(dirname "$target")
      cp "$file" "$target"
      echo "✅ Added: $file"
    else
      echo "⚠️ File not found: $file"
    fi
  done
  
  # Update version
  if command -v jq &>/dev/null; then
    jq ".frontend = \"$VERSION\" | .backend = \"$VERSION\"" version.json > version.tmp && mv version.tmp version.json
    echo "📝 Updated version to $VERSION"
  else
    echo "⚠️ jq not installed, version.json not updated"
  fi
  
  echo "🎉 Patch $VERSION created successfully"
}

function clean_patches() {
  find patches -maxdepth 1 -type d -name "v0.*" | sort -V | head -n -3 | xargs -I{} rm -rf {}
  echo "🧹 Removed old patches, keeping the 3 most recent"
}

# Main command processing
case "$1" in
  apply)
    apply_patch "$2"
    ;;
  list)
    list_patches
    ;;
  create)
    shift
    create_patch "$@"
    ;;
  clean)
    clean_patches
    ;;
  *)
    show_help
    ;;
esac
EOF

chmod +x patch_manager.sh

# Clean up patches directory
mkdir -p patches_archive
mv patches/v0.1* patches/v0.2.[0-5]* patches_archive/ 2>/dev/null || true

# Create simplified README
cat << 'EOF' > README.simplified.md
# Costume Scheduler

A lightweight browser-based app for managing wardrobe logistics for theater productions.

## Features

- 📅 Schedule dressing times by actor, dresser, and wardrobe item
- 📊 Visual Gantt chart with debug JSON panel
- 🔹 Tasks with deadlines, wardrobe inventory management
- 💡 Designed for airgapped or offline use

## Getting Started

### 1. Install dependencies
python3 -m venv venv
source venv/bin/activate
pip install flask

### 2. Run the server
python3 backend/app.py

Then visit http://127.0.0.1:5000

### 3. Load demo data (optional)
cp data/scheduler_data_demo.json data/scheduler_data.json

## Simplified Patching System

The project includes a simplified patch management tool:

# Apply a patch
./patch_manager.sh apply v0.3.2

# Create a new patch with specific files
./patch_manager.sh create backend/app.py frontend/static/js/script.js

# List available patches
./patch_manager.sh list

# Clean up old patches
./patch_manager.sh clean

## Data Format

The app uses a JSON structure with:
- agents: Lists of actors, dressers, and managers
- schedules: Assignments of actors, dressers and items at specific times
- tasks: Tasks with deadlines and assignments
- wardrobe_items: Inventory of costume pieces

## Troubleshooting

- If port 5000 is already in use, the app will prompt for an alternative
- Make sure to use HTTP not HTTPS when accessing locally
- Check logs folder for debug information
EOF

# Move dev utilities to archive
mkdir -p dev_archive_simplified
mv apply_*.sh dev_archive_simplified/ 2>/dev/null || true
mv temp_*.sh dev_archive_simplified/ 2>/dev/null || true
mv prepare_*.sh dev_archive_simplified/ 2>/dev/null || true
mv *patcher.sh dev_archive_simplified/ 2>/dev/null || true
mv clean_*.sh dev_archive_simplified/ 2>/dev/null || true

echo "✅ Cleanup complete!"
echo "📋 Recommendations:"
echo "  1. Review README.simplified.md and replace the current README.md if you approve"
echo "  2. Use the new patch_manager.sh instead of multiple patch scripts"
echo "  3. Run './patch_manager.sh clean' to remove old patches"
echo "  4. Consider using a proper version control system like Git instead of custom patching"
echo ""
echo "Run the app with: python3 backend/app.py"
