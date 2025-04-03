// PATCH v0.3.1 – Gantt Chart Restored + Version Debug + Cache Busting
console.log("🧩 Frontend Script Version: v0.3.1");

function renderGanttChart(data, selectedDate = null) {
  const container = document.getElementById("ganttContainer");
  container.innerHTML = "";

  const schedules = data.schedules || [];
  const date = selectedDate || new Date().toISOString().split("T")[0];
  const filtered = schedules.filter(entry => entry.time.startsWith(date));

  console.log("📆 Selected Date:", date);
  console.log("🎯 Filtered Entries:", filtered);

  if (filtered.length === 0) {
    container.innerHTML = "<p style='padding:1em;'>No schedule entries found for selected date.</p>";
    return;
  }

  const table = document.createElement("table");
  table.innerHTML = `
    <thead>
      <tr>
        <th>Actor</th>
        <th>Dresser</th>
        <th>Item</th>
        <th>Time</th>
        <th>Duration</th>
      </tr>
    </thead>
    <tbody>
      ${filtered.map(entry => `
        <tr>
          <td>${entry.actor}</td>
          <td>${entry.dresser}</td>
          <td>${entry.item}</td>
          <td>${new Date(entry.time).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</td>
          <td>${entry.duration_minutes} min</td>
        </tr>
      `).join("")}
    </tbody>
  `;
  container.appendChild(table);
}

function renderDebugPanel(data) {
  const debugEl = document.getElementById("debugPanel");
  if (debugEl) {
    debugEl.textContent = JSON.stringify(data, null, 2);
  }

  const versionTag = document.getElementById("versionTag");
  if (versionTag && data.version) {
    versionTag.textContent = `Frontend: v0.3.1 / Backend: ${data.version}`;
  }
}

function addCopyButton(data) {
  if (document.getElementById("copyJsonBtn")) return;
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
      console.log("🟢 API Data:", data);
      renderGanttChart(data, dateOverride);
      renderDebugPanel(data);
      addCopyButton(data);
    })
    .catch(err => console.error("❌ Failed to fetch /api/data:", err));
}

document.addEventListener("DOMContentLoaded", () => {
  const dateInput = document.getElementById("dateSelector");
  const today = new Date().toISOString().split("T")[0];
  dateInput.value = today;
  dateInput.addEventListener("change", () => fetchDataAndRender(dateInput.value));
  fetchDataAndRender(today);
});

