#!/bin/bash

PATCH_VERSION=$1
PATCH_DIR="patches/$PATCH_VERSION"
README_FILE="$PATCH_DIR/README.md"
DATE=$(date +%Y-%m-%d)

mkdir -p "$PATCH_DIR"

cat <<EOF > "$README_FILE"
# Patch $PATCH_VERSION – Smart Port Handling

### 🧠 Summary
- Adds port availability check to \`app.py\`
- Automatically identifies the PID using port 5000
- Prompts the user to kill or select an alternate port
- Prevents Flask from crashing if the port is already bound

### 📁 Files Modified
- \`backend/app.py\`

### 📅 Date
$DATE

### ✅ How to Apply
\`\`\`bash
python3 apply_patch.py
# Enter: $PATCH_VERSION
\`\`\`

### 🔁 Related Version
- Updated \`version.json\` to \`$PATCH_VERSION\`
EOF

echo "✅ Created README at $README_FILE"

