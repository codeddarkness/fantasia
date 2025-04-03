#!/bin/bash
set -e

VERSION="$1"
if [ -z "$VERSION" ]; then
  echo "Usage: bash apply_all_patches.sh v0.X.Y"
  exit 1
fi

PATCH_DIR="patches/$VERSION"
UPDATES_DIR="updates"

echo "📦 Applying patch: $VERSION"
mkdir -p "$PATCH_DIR"

FILES_APPLIED=0

for file in "$UPDATES_DIR"/*; do
  [[ -f "$file" ]] || continue

  # Extract destination path from header comment
  PATCH_PATH=$(grep -oE '^<!-- PATCH-PATH: .* -->' "$file" | sed -E 's/<!-- PATCH-PATH: (.*) -->/\1/' || true)

  if [ -z "$PATCH_PATH" ]; then
    echo "⚠️  Skipping $file (no PATCH-PATH header)"
    continue
  fi

  DEST_DIR=$(dirname "$PATCH_PATH")
  echo "🔧 Moving: $file → $PATCH_PATH"

  # Save into patch archive
  mkdir -p "$PATCH_DIR/$DEST_DIR"
  cp "$file" "$PATCH_DIR/$PATCH_PATH"

  # Apply live patch
  mkdir -p "$DEST_DIR"
  cp "$file" "$PATCH_PATH"

  FILES_APPLIED=$((FILES_APPLIED + 1))
done

if [ "$FILES_APPLIED" -eq 0 ]; then
  echo "❌ No patchable files found in $UPDATES_DIR."
  exit 1
fi

# Update version.json
if command -v jq &>/dev/null; then
  jq --arg v "$VERSION" '.frontend = $v' version.json > version.tmp && mv version.tmp version.json
  echo "📝 Updated version.json to frontend=$VERSION"
else
  echo "⚠️  jq not found, skipping version.json update"
fi

echo "✅ Patch $VERSION applied."

