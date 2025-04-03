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

apply_file() {
  src="$1"
  dest="$2"
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest" && echo "✅ Patched $dest"
}

# Apply known patch files
[ -f "$PATCH_DIR/backend/app.py" ] && apply_file "$PATCH_DIR/backend/app.py" "backend/app.py"
[ -f "$PATCH_DIR/frontend/static/js/script.js" ] && apply_file "$PATCH_DIR/frontend/static/js/script.js" "frontend/static/js/script.js"
[ -f "$PATCH_DIR/frontend/templates/index.html" ] && apply_file "$PATCH_DIR/frontend/templates/index.html" "frontend/templates/index.html"

# Update version.json
if command -v jq &> /dev/null; then
  jq '.frontend = "'$PATCH_VERSION'" | .backend = "'$PATCH_VERSION'"' version.json > version.tmp && mv version.tmp version.json
  echo "📝 Updated version.json to $PATCH_VERSION"
fi

echo "🎉 Patch $PATCH_VERSION applied. Launch with:"
echo "   python3 backend/app.py"
EOF

chmod +x apply_patch_v0.3.1.sh

