async function loadData() {
    const res = await fetch("/api/data");
    const data = await res.json();
    buildGantt(data.schedules);
}

function buildGantt(schedules) {
    const container = document.getElementById("ganttContainer");
    container.innerHTML = "";

    const table = document.createElement("table");
    table.border = "1";
    table.style.borderCollapse = "collapse";

    const startHour = 17; // 5PM
    const endHour = 23;   // 11PM
    const totalMinutes = (endHour - startHour) * 60;
    const slots = totalMinutes / 5;

    // Build header row
    const header = document.createElement("tr");
    const blank = document.createElement("th");
    blank.innerText = "Assignment";
    header.appendChild(blank);
    for (let i = 0; i < slots; i++) {
        const th = document.createElement("th");
        const hour = Math.floor(i * 5 / 60) + startHour;
        const minute = (i * 5) % 60;
        th.innerText = `${hour}:${minute.toString().padStart(2, "0")}`;
        header.appendChild(th);
    }
    table.appendChild(header);

    // Build one row per assignment
    schedules.forEach((entry, index) => {
        const row = document.createElement("tr");
        const label = document.createElement("td");
        label.innerText = `${entry.actor} (${entry.dresser})`;
        row.appendChild(label);

        for (let i = 0; i < slots; i++) {
            const td = document.createElement("td");
            const cellTime = startHour * 60 + i * 5;
            const start = new Date(entry.time);
            const startMinutes = start.getHours() * 60 + start.getMinutes();
            const endMinutes = startMinutes + (entry.duration_minutes || 10);

            if (cellTime >= startMinutes && cellTime < endMinutes) {
                td.style.backgroundColor = "#aaf"; // Scheduled
                td.title = `${entry.item}`;
            }

            row.appendChild(td);
        }

        table.appendChild(row);
    });

    // Simple overlap highlight
    const rows = table.querySelectorAll("tr:not(:first-child)");
    for (let col = 1; col <= slots; col++) {
        let active = 0;
        rows.forEach(row => {
            const cell = row.children[col];
            if (cell.style.backgroundColor === "rgb(170, 170, 255)") {
                active++;
                if (active > 1) cell.style.backgroundColor = "red";
            }
        });
    }

    container.appendChild(table);
}

function exportCSV() {
    alert("CSV export coming soon!");
}

window.onload = loadData;

