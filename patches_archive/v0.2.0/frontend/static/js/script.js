let fullData = {};

async function loadData() {
    const res = await fetch("/api/data");
    fullData = await res.json();
    buildForm(fullData);
    buildGantt(fullData.schedules);
}

function buildForm(data) {
    const container = document.getElementById("ganttContainer");

    const form = document.createElement("div");
    form.innerHTML = `
        <h3>Add Schedule Entry</h3>
        <select id="actor"></select>
        <select id="dresser"></select>
        <select id="item"></select>
        <input type="datetime-local" id="startTime">
        <input type="number" id="duration" value="10" min="1"> min
        <button onclick="submitEntry()">Add</button>
        <hr>
    `;

    populateDropdown("actor", data.agents.actors);
    populateDropdown("dresser", data.agents.dressers);
    populateDropdown("item", data.wardrobe_items.map(w => w.id));

    container.innerHTML = ""; // Clear old content
    container.appendChild(form);
}

function populateDropdown(id, items) {
    const select = document.getElementById(id);
    items.forEach(item => {
        const opt = document.createElement("option");
        opt.value = item;
        opt.textContent = item;
        select.appendChild(opt);
    });
}

function submitEntry() {
    const actor = document.getElementById("actor").value;
    const dresser = document.getElementById("dresser").value;
    const item = document.getElementById("item").value;
    const time = document.getElementById("startTime").value;
    const duration = parseInt(document.getElementById("duration").value, 10);

    if (!actor || !dresser || !item || !time) {
        alert("Fill all fields.");
        return;
    }

    fullData.schedules.push({ actor, dresser, item, time, duration_minutes: duration });

    fetch("/api/update", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(fullData)
    }).then(res => {
        if (res.ok) {
            loadData();
        } else {
            alert("Failed to update schedule.");
        }
    });
}

function buildGantt(schedules) {
    const table = document.createElement("table");
    table.border = "1";
    table.style.borderCollapse = "collapse";

    const startHour = 17;
    const endHour = 23;
    const slots = ((endHour - startHour) * 60) / 5;

    const header = document.createElement("tr");
    header.innerHTML = "<th>Assignment</th>";
    for (let i = 0; i < slots; i++) {
        const h = Math.floor(i * 5 / 60) + startHour;
        const m = (i * 5) % 60;
        header.innerHTML += `<th>${h}:${m.toString().padStart(2, '0')}</th>`;
    }
    table.appendChild(header);

    schedules.forEach(entry => {
        const row = document.createElement("tr");
        row.innerHTML = `<td>${entry.actor} (${entry.dresser})</td>`;

        const start = new Date(entry.time);
        const startMin = start.getHours() * 60 + start.getMinutes();
        const endMin = startMin + (entry.duration_minutes || 10);

        for (let i = 0; i < slots; i++) {
            const currentMin = startHour * 60 + i * 5;
            const td = document.createElement("td");

            if (currentMin >= startMin && currentMin < endMin) {
                td.style.backgroundColor = "#aaf";
                td.title = entry.item;
            }

            row.appendChild(td);
        }

        table.appendChild(row);
    });

    document.getElementById("ganttContainer").appendChild(table);
}

function exportCSV() {
    const rows = [["Actor", "Dresser", "Item", "Time", "Duration"]];
    fullData.schedules.forEach(e =>
        rows.push([e.actor, e.dresser, e.item, e.time, e.duration_minutes])
    );

    const csvContent = rows.map(r => r.join(",")).join("\n");
    const blob = new Blob([csvContent], { type: "text/csv" });
    const url = URL.createObjectURL(blob);

    const a = document.createElement("a");
    a.href = url;
    a.download = "schedule.csv";
    a.click();
}

window.onload = loadData;

