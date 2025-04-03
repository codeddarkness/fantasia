#!/bin/bash
set -e

PATCH_VERSION="v0.3.2"
PATCH_DIR="patches/$PATCH_VERSION"

mkdir -p "$PATCH_DIR/static/js"
mkdir -p "$PATCH_DIR/frontend/templates"

# script.js – working Gantt + debug panel + copy + version
cat <<'EOF' > "$PATCH_DIR/static/js/script.js"
console.log("🧩 Frontend Script Version: v0.3.2");

function renderGanttChart(data, selectedDate = null) {
  const container = document.getElementById("ganttContainer");
  container.innerHTML = "";

  const schedules = data.schedules || [];
  const date = selectedDate || new Date().toISOString().split("T")[0];
  const filtered = schedules.filter(entry => entry.time.startsWith(date));

  if (filtered.length === 0) {
    container.innerHTML = "<p style='padding:1em;'>No schedule entries found for selected date.</p>";
    return;
  }

  filtered.forEach(entry => {
    const row = document.createElement("div");
    row.className = "gantt-row";
    row.innerHTML = `
      <div class="gantt-bar">
        ${entry.time.split("T")[1].slice(0,5)} - ${entry.actor} (${entry.item}) w/ ${entry.dresser} [${entry.duration_minutes} min]
      </div>
    `;
    container.appendChild(row);
  });
}

function renderDebugPanel(data) {
  const debugEl = document.getElementById("debugPanel");
  if (debugEl) {
    debugEl.textContent = JSON.stringify(data, null, 2);
  }

  const versionTag = document.getElementById("versionTag");
  if (versionTag && data.version) {
    versionTag.textContent = `Frontend: v0.3.2 / Backend: ${data.version}`;
  }
}

function addCopyButton(data) {
  const existing = document.getElementById("copyJsonBtn");
  if (existing) return;

  const btn = document.createElement("button");
  btn.id = "copyJsonBtn";
  btn.textContent = "📋 Copy JSON to Clipboard";
  btn.onclick = () => {
    navigator.clipboard.writeText(JSON.stringify(data, null, 2));
    alert("Copied JSON to clipboard!");
  };
  document.body.appendChild(btn);
}

function fetchDataAndRender(dateOverride = null) {
  fetch("/api/data")
    .then(res => res.json())
    .then(data => {
      renderGanttChart(data, dateOverride);
      renderDebugPanel(data);
      addCopyButton(data);
    })
    .catch(err => {
      console.error("❌ Failed to fetch /api/data:", err);
    });
}

document.addEventListener("DOMContentLoaded", () => {
  const dateInput = document.getElementById("dateSelector");
  const today = new Date().toISOString().split("T")[0];
  dateInput.value = today;
  dateInput.addEventListener("change", () => fetchDataAndRender(dateInput.value));
  fetchDataAndRender(today);
});
EOF

# index.html with script reference and CSS classes
cat <<'EOF' > "$PATCH_DIR/frontend/templates/index.html"
<!DOCTYPE html>
<html>
<head>
  <title>Costume Scheduler</title>
  <link rel="stylesheet" href="/static/css/styles.css">
  <style>
    .gantt-bar {
      background-color: #4caf50;
      color: white;
      padding: 4px;
      margin: 4px 0;
      border-radius: 4px;
      width: fit-content;
    }
    .gantt-row {
      margin-bottom: 8px;
    }
  </style>
</head>
<body>
  <h1>Costume Scheduler</h1>
  <input type="date" id="dateSelector">
  <div id="ganttContainer"></div>

  <button onclick="exportCSV()">Export CSV</button>
  <a href="/api/download" download><button>Download JSON</button></a>
  <input type="file" id="uploadInput">
  <button onclick="uploadJSON()">Upload JSON</button>

  <pre id="debugPanel" style="margin-top:1em; padding:1em; background:#f9f9f9; border:1px solid #ccc; max-height:300px; overflow:auto;"></pre>
  <span id="versionTag" style="font-size: 0.9em; color: gray; display: block; margin-bottom: 1em;"></span>

  <script src="/static/js/script.js?v=0.3.2"></script>
</body>
</html>
EOF

# Generate patch script
cat <<EOF > apply_patch_v0.3.2.sh
#!/bin/bash
set -e

PATCH_VERSION="v0.3.2"
PATCH_DIR="patches/\$PATCH_VERSION"

echo "🔧 Applying Patch: \$PATCH_VERSION"
echo "📁 From Directory: \$PATCH_DIR"

if [ ! -d "\$PATCH_DIR" ]; then
  echo "❌ Patch directory \$PATCH_DIR not found."
  exit 1
fi

mkdir -p frontend/static/js
cp "\$PATCH_DIR/static/js/script.js" frontend/static/js/script.js && echo "✅ Patched script.js"

mkdir -p frontend/templates
cp "\$PATCH_DIR/frontend/templates/index.html" frontend/templates/index.html && echo "✅ Patched index.html"

if ! command -v jq &> /dev/null; then
  echo "❌ 'jq' is required but not installed."
  exit 1
fi

jq '.frontend = "'\$PATCH_VERSION'"' version.json > version.tmp && mv version.tmp version.json
echo "📝 Updated frontend version to \$PATCH_VERSION"
echo "🎉 Patch \$PATCH_VERSION applied. Restart with:"
echo "   python3 backend/app.py"
EOF

chmod +x apply_patch_v0.3.2.sh

echo "✅ Patch files written. Run with:"
echo "   bash apply_patch_v0.3.2.sh"

