#!/bin/bash
set -e

PATCH_VERSION="v0.3.5"
PATCH_DIR="patches/$PATCH_VERSION"
echo "📦 Preparing patch $PATCH_VERSION"

# Create directory structure
mkdir -p "$PATCH_DIR/backend"
mkdir -p "$PATCH_DIR/frontend/templates"
mkdir -p "$PATCH_DIR/frontend/static/js"
mkdir -p "$PATCH_DIR/frontend/static/css"

# Copy current files
cp backend/app.py "$PATCH_DIR/backend/app.py"
cp frontend/templates/index.html "$PATCH_DIR/frontend/templates/index.html"
cp frontend/static/js/script.js "$PATCH_DIR/frontend/static/js/script.js"
cp frontend/static/css/styles.css "$PATCH_DIR/frontend/static/css/styles.css"

# Inject path comment header
for f in $(find "$PATCH_DIR" -type f); do
  relpath="${f#patches/$PATCH_VERSION/}"
  echo "// PATCH $PATCH_VERSION - From: $relpath" | cat - "$f" > "$f.tmp" && mv "$f.tmp" "$f"
done

# Update version.json
if command -v jq &>/dev/null; then
  jq ".frontend = \"$PATCH_VERSION\"" version.json > version.tmp && mv version.tmp version.json
  echo "📝 version.json updated to frontend $PATCH_VERSION"
else
  echo "⚠️ jq not installed – skipping version update"
fi

# Update README.md
if [ -f README.md ]; then
  echo "- v$PATCH_VERSION: Consolidated frontend + backend patch with test page additions" >> README.md
  echo "📘 README.md updated"
fi

echo "✅ Patch $PATCH_VERSION prepared."
echo "➡️  Now run: python3 backend/app.py"

