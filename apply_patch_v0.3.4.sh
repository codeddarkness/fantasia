#!/bin/bash
set -e

PATCH_VERSION="v0.3.4"
PATCH_DIR="patches/$PATCH_VERSION"

echo "🔧 Applying Patch: $PATCH_VERSION"
echo "📁 From: $PATCH_DIR"

if [ ! -d "$PATCH_DIR" ]; then
  echo "❌ Patch directory does not exist: $PATCH_DIR"
  exit 1
fi

if ! command -v jq &> /dev/null; then
  echo "❌ 'jq' is required but not installed."
  exit 1
fi

UPDATED_FILES=0

# Recursively apply each patch with PATCH-PATH header
while IFS= read -r -d '' file; do
  DEST_PATH=$(grep '^<!-- PATCH-PATH:' "$file" | sed -E 's/<!-- PATCH-PATH: (.+) -->/\1/')
  if [ -z "$DEST_PATH" ]; then
    echo "⚠️  Skipping: $file (no PATCH-PATH header)"
    continue
  fi

  mkdir -p "$(dirname "$DEST_PATH")"
  cp "$file" "$DEST_PATH"
  echo "✅ Patched: $DEST_PATH"
  UPDATED_FILES=$((UPDATED_FILES + 1))
done < <(find "$PATCH_DIR" -type f -name '*.html' -print0)

# Handle JS updates
if [ -f "$PATCH_DIR/static/js/script.js" ]; then
  mkdir -p frontend/static/js
  cp "$PATCH_DIR/static/js/script.js" frontend/static/js/script.js
  echo "✅ Patched: frontend/static/js/script.js"
  UPDATED_FILES=$((UPDATED_FILES + 1))
fi

# Handle version update
jq ".frontend = \"$PATCH_VERSION\"" version.json > version.tmp && mv version.tmp version.json
echo "📝 Updated version.json to frontend: $PATCH_VERSION"

if [ "$UPDATED_FILES" -eq 0 ]; then
  echo "⚠️  No files were patched."
else
  echo "🎉 Patch $PATCH_VERSION applied with $UPDATED_FILES file(s)."
  echo "👉 Restart the app: python3 backend/app.py"
fi

