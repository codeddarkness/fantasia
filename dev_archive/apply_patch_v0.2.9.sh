#!/bin/bash
set -e

PATCH_VERSION="v0.2.9"
PATCH_DIR="patches/$PATCH_VERSION"

echo "🔧 Applying Patch: $PATCH_VERSION"
echo "📁 From Directory: $PATCH_DIR"

if [ ! -f "$PATCH_DIR/static/js/script.js" ]; then
  echo "❌ Missing script.js at $PATCH_DIR/static/js/"
  exit 1
fi

mkdir -p frontend/static/js
cp "$PATCH_DIR/static/js/script.js" frontend/static/js/script.js
echo "✅ Patched script.js"

# Update version.json
jq '.frontend = "'$PATCH_VERSION'"' version.json > version.tmp && mv version.tmp version.json
echo "📝 Updated version.json to frontend=$PATCH_VERSION"
echo "🎉 Patch $PATCH_VERSION applied. Restart with:"
echo "   python3 backend/app.py"
