#!/bin/bash
set -e

PATCH_VERSION="v0.3.6"
PATCH_DIR="patches/$PATCH_VERSION"
mkdir -p "$PATCH_DIR/frontend/templates"

echo "🔧 Applying Patch: $PATCH_VERSION"
echo "📁 Creating template files for test pages..."

# Create test.html
cat << 'EOF' > "$PATCH_DIR/frontend/templates/test.html"
<!DOCTYPE html>
<html>
<head>
  <title>Test View</title>
</head>
<body>
  <h2>Side-by-side Chart Previews</h2>
  <div style="display:flex;gap:2em">
    <iframe src="/legacy-preview" style="width:48%; height:600px; border:1px solid #ccc;"></iframe>
    <iframe src="/vis-preview" style="width:48%; height:600px; border:1px solid #ccc;"></iframe>
  </div>
</body>
</html>
EOF

# Create legacy_gantt_preview.html
cat << 'EOF' > "$PATCH_DIR/frontend/templates/legacy_gantt_preview.html"
<!DOCTYPE html>
<html>
<head>
  <title>Legacy Gantt Preview</title>
  <style>
    body { font-family: sans-serif; }
    .gantt-bar {
      background-color: #4caf50;
      color: white;
      padding: 4px;
      margin: 4px 0;
      border-radius: 4px;
      width: fit-content;
    }
    .gantt-row { margin-bottom: 8px; }
  </style>
</head>
<body>
  <h2>Legacy Gantt Style (Static)</h2>
  <div class="gantt-row"><div class="gantt-bar">Alice - 18:00 (Top Hat)</div></div>
  <div class="gantt-row"><div class="gantt-bar">Bob - 18:15 (Red Dress)</div></div>
  <div class="gantt-row"><div class="gantt-bar">Charlie - 18:30 (Trench Coat)</div></div>
</body>
</html>
EOF

# Create vis_gantt_preview.html
cat << 'EOF' > "$PATCH_DIR/frontend/templates/vis_gantt_preview.html"
<!DOCTYPE html>
<html>
<head>
  <title>vis.js Gantt Preview</title>
  <script src="https://unpkg.com/vis-timeline@latest/standalone/umd/vis-timeline-graph2d.min.js"></script>
  <link href="https://unpkg.com/vis-timeline@latest/styles/vis-timeline-graph2d.min.css" rel="stylesheet" />
</head>
<body>
  <h2>vis.js Gantt Timeline</h2>
  <div id="visualization" style="height: 400px;"></div>
  <script>
    const container = document.getElementById('visualization');
    const items = new vis.DataSet([
      {id: 1, content: 'Alice (Top Hat)', start: '2025-04-02T18:00:00', end: '2025-04-02T18:10:00'},
      {id: 2, content: 'Bob (Red Dress)', start: '2025-04-02T18:15:00', end: '2025-04-02T18:27:00'},
      {id: 3, content: 'Charlie (Trench Coat)', start: '2025-04-02T18:30:00', end: '2025-04-02T18:38:00'},
    ]);
    const timeline = new vis.Timeline(container, items, {});
  </script>
</body>
</html>
EOF

# Copy files to frontend
cp "$PATCH_DIR/frontend/templates/"*.html frontend/templates/

# Ensure routes exist in app.py
APP_FILE="backend/app.py"
ROUTE_MARKER="# PATCH v0.3.6 routes"
if ! grep -q "$ROUTE_MARKER" "$APP_FILE"; then
  echo "🔧 Patching Flask routes into $APP_FILE..."
  cat <<EOF >> "$APP_FILE"

$ROUTE_MARKER
@app.route("/test")
def test_view(): return render_template("test.html")

@app.route("/legacy-preview")
def legacy_preview(): return render_template("legacy_gantt_preview.html")

@app.route("/vis-preview")
def vis_preview(): return render_template("vis_gantt_preview.html")
EOF
else
  echo "✅ Routes already exist in $APP_FILE"
fi

# Update version.json
jq '.frontend = "'$PATCH_VERSION'"' version.json > version.tmp && mv version.tmp version.json
echo "📝 Updated frontend version to $PATCH_VERSION"

echo "🎉 Patch $PATCH_VERSION applied. Restart with:"
echo "   python3 backend/app.py"

