#!/bin/bash
set -e

PATCH_VERSION="v0.2.8"
PATCH_DIR="patches/$PATCH_VERSION"

echo "🔧 Applying Patch: $PATCH_VERSION"
echo "📁 From Directory: $PATCH_DIR"

if [ ! -d "$PATCH_DIR" ]; then
  echo "❌ Patch directory $PATCH_DIR not found."
  exit 1
fi

# Copy updated frontend JS
echo "📄 Copying script.js..."
mkdir -p frontend/static/js
cp "$PATCH_DIR/static/js/script.js" frontend/static/js/script.js
echo "✅ Patched script.js"

# Update version.json (frontend only)
if ! command -v jq &> /dev/null; then
  echo "❌ 'jq' is required but not installed."
  exit 1
fi

jq '.frontend = "'$PATCH_VERSION'"' version.json > version.tmp && mv version.tmp version.json
echo "📝 Updated version.json to frontend=$PATCH_VERSION"

echo "🎉 Patch $PATCH_VERSION applied. Restart the app:"
echo "   python3 backend/app.py"
