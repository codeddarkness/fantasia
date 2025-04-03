import os
import json

VERSION = "0.1.0"
PROJECT_NAME = "costume_scheduler"

folders = [
    "backend",
    "frontend/static/css",
    "frontend/static/js",
    "frontend/templates",
    "data"
]

files = {
    "backend/__init__.py": "",
    "backend/app.py": '''from flask import Flask, render_template, request, jsonify
import json
from datetime import datetime

app = Flask(__name__)

DB_FILE = "data/costume_shop.json"

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/api/data")
def get_data():
    with open(DB_FILE, "r") as f:
        return jsonify(json.load(f))

@app.route("/api/update", methods=["POST"])
def update_data():
    new_data = request.json
    with open(DB_FILE, "w") as f:
        json.dump(new_data, f, indent=2)
    return {"status": "ok"}

if __name__ == "__main__":
    app.run(debug=True)
''',

    "frontend/templates/index.html": '''<!DOCTYPE html>
<html>
<head>
    <title>Costume Scheduler</title>
    <link rel="stylesheet" href="/static/css/styles.css">
</head>
<body>
    <h1>Costume Scheduler</h1>
    <input type="date" id="dateSelector">
    <div id="ganttContainer"></div>
    <button onclick="exportCSV()">Export CSV</button>
    <script src="/static/js/script.js"></script>
</body>
</html>
''',

    "frontend/static/css/styles.css": '''body { font-family: Arial, sans-serif; padding: 20px; }
#ganttContainer { margin-top: 20px; }
.overlap { background-color: red; }
''',

    "frontend/static/js/script.js": '''async function loadData() {
    const res = await fetch("/api/data");
    const data = await res.json();
    console.log(data);
    // TODO: Build Gantt chart here
}

function exportCSV() {
    // Placeholder for CSV export
    alert("CSV export not implemented yet");
}

window.onload = loadData;
''',

    "data/costume_shop.json": json.dumps({
        "version": VERSION,
        "wardrobe_items": [],
        "agents": {
            "dressers": [],
            "actors": [],
            "managers": []
        },
        "tasks": [],
        "schedules": [],
        "productions": []
    }, indent=2),

    "version.json": json.dumps({"backend": VERSION, "frontend": VERSION}, indent=2),

    ".gitignore": "data/*.json\n__pycache__/"
}

def create_structure():
    for folder in folders:
        os.makedirs(folder, exist_ok=True)
    for path, content in files.items():
        with open(path, "w") as f:
            f.write(content)

    print(f"✅ {PROJECT_NAME} scaffold created successfully.")

if __name__ == "__main__":
    create_structure()

