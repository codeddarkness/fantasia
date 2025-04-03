# Costume Scheduler

A lightweight browser-based app for managing wardrobe logistics for theater productions.

## Features

- 📅 Schedule dressing times by actor, dresser, and wardrobe item
- 📊 Visual Gantt chart with optional debug JSON panel
- 🔹 Tasks with deadlines, wardrobe inventory management
- 💡 Designed for airgapped or offline use

## Getting Started

### 1. Install dependencies
```bash
python3 -m venv venv
source venv/bin/activate
pip install flask
```

### 2. Run the server
```bash
python3 backend/app.py
```
Then visit [http://127.0.0.1:5000](http://127.0.0.1:5000)

### 3. Load demo data (optional)
```bash
cp data/scheduler_data_demo.json data/scheduler_data.json
```

---

## Folder Structure
```
my_wardrobe/
├── backend/              # Flask backend
├── frontend/             # Templates + static JS
│   └── static/js/
├── data/                 # JSON schedule/inventory
├── logs/                 # Frontend check logs
├── patches/              # Patch folders per version
├── dev_archive/          # Archived dev scripts
├── version.json          # Tracks backend + frontend version
```

## Developer Utilities

| Script               | Purpose                          |
|----------------------|----------------------------------|
| `check_frontend.sh` | Validate web endpoints + assets |
| `apply_patch_*.sh`  | Apply version patches           |
| `clean_workspace.sh`| Archive helper scripts           |
| `make_patch.py`     | Create patch directories         |

## API Reference

`GET /api/data` returns:
```json
{
  "agents": {
    "actors": [],
    "dressers": [],
    "managers": []
  },
  "schedules": [
    {
      "actor": "",
      "dresser": "",
      "item": "",
      "time": "",
      "duration_minutes": 0
    }
  ],
  "tasks": [
    {
      "name": "",
      "assigned_to": "",
      "deadline": ""
    }
  ],
  "wardrobe_items": [
    {
      "id": "",
      "name": "",
      "size": ""
    }
  ]
}
```

## Versioning
Check `version.json` for current version:
```json
{
  "backend": "v0.2.6",
  "frontend": "v0.3.0"
}
```

## Notes
- App runs with Flask's built-in server; do **not** use in production as-is.
- Use **HTTP**, not HTTPS, in development.
- JavaScript supports cache-busting via version query string (e.g., `script.js?v=0.3.0`)

---

For bugs or feature updates, refer to `CHANGELOG.md` or use included patching system.
- vv0.3.5: Consolidated frontend + backend patch with test page additions
- vv0.3.5: Consolidated frontend + backend patch with test page additions
