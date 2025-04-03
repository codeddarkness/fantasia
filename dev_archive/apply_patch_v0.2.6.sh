#!/bin/bash

PATCH_VERSION="v0.2.6"
PATCH_DIR="patches/$PATCH_VERSION"

if [ ! -d "$PATCH_DIR" ]; then
  echo "❌ Patch directory $PATCH_DIR not found."
  exit 1
fi

# Copy updated backend/app.py
mkdir -p backend
cp "$PATCH_DIR/backend/app.py" backend/app.py && echo "✅ Patched backend/app.py"

# Update version.json
cat <<JSON > version.json
{
  "backend": "$PATCH_VERSION",
  "frontend": "$PATCH_VERSION"
}
JSON

echo "📝 Updated version.json to $PATCH_VERSION"

# Confirm
echo "\n🎉 Patch $PATCH_VERSION applied. Launch with:"
echo "   python3 backend/app.py"
