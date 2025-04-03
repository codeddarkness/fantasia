// PATCH v0.2.7 - Improved Gantt Chart Rendering and Debugging

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

function fetchDataAndRender(dateOverride = null) {
  fetch("/api/data")
    .then(res => res.json())
    .then(data => {
      console.log("🟢 API Data:", data);
      renderGanttChart(data, dateOverride);
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

