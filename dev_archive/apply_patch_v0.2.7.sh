#!/bin/bash

PATCH_VERSION="v0.2.7"
PATCH_DIR="patches/$PATCH_VERSION"

if [ ! -d "$PATCH_DIR" ]; then
  echo "❌ Patch directory $PATCH_DIR not found."
  exit 1
fi

# Copy updated frontend JS
mkdir -p frontend/static/js
cp "$PATCH_DIR/frontend/static/js/script.js" frontend/static/js/script.js && echo "✅ Patched script.js"

# Update version.json
cat <<JSON > version.json
{
  "backend": "v0.2.6",
  "frontend": "$PATCH_VERSION"
}
JSON

echo "📝 Updated frontend version to $PATCH_VERSION"
echo "🎉 Patch $PATCH_VERSION applied. Restart the app:"
echo "   python3 backend/app.py"
