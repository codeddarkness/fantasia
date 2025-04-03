cat << 'EOF' > apply_patch_v0.2.7.sh
#!/bin/bash

PATCH_VERSION="v0.2.7"
PATCH_DIR="patches/$PATCH_VERSION"

if [ ! -d "$PATCH_DIR" ]; then
  echo "❌ Patch directory $PATCH_DIR not found."
  exit 1
fi

# Copy updated script.js
mkdir -p frontend/static/js
cp "$PATCH_DIR/frontend/static/js/script.js" frontend/static/js/script.js && echo "✅ Patched frontend/static/js/script.js"

# Update version.json
cat <<JSON > version.json
{
  "backend": "v0.2.6",
  "frontend": "$PATCH_VERSION"
}
JSON

echo "📝 Updated frontend version to $PATCH_VERSION"

# Confirm
echo -e "\n🎉 Patch $PATCH_VERSION applied. Reload your browser and check the chart."
EOF

chmod +x apply_patch_v0.2.7.sh

