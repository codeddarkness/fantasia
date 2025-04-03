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
