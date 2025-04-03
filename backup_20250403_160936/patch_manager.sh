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
