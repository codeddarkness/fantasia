cat << 'EOF' > apply_patch_v0.3.1.sh
#!/bin/bash
set -e

PATCH_VERSION="v0.3.1"
PATCH_DIR="patches/$PATCH_VERSION"

echo "🔧 Applying Patch: $PATCH_VERSION"
echo "📁 From Directory: $PATCH_DIR"

if [ ! -d "$PATCH_DIR" ]; then
  echo "❌ Patch directory $PATCH_DIR not found."
  exit 1
fi

# Copy frontend files
mkdir -p frontend/static/js
cp "$PATCH_DIR/static/js/script.js" frontend/static/js/script.js && echo "✅ Patched script.js"

mkdir -p frontend/templates
cp "$PATCH_DIR/frontend/templates/index.html" frontend/templates/index.html && echo "✅ Patched index.html"

# Update version.json
if ! command -v jq &> /dev/null; then
  echo "❌ 'jq' is required but not installed."
  exit 1
fi

jq '.frontend = "'$PATCH_VERSION'"' version.json > version.tmp && mv version.tmp version.json
echo "📝 Updated frontend version to $PATCH_VERSION"
echo "🎉 Patch $PATCH_VERSION applied. Restart with:"
echo "   python3 backend/app.py"
EOF

chmod +x apply_patch_v0.3.1.sh

