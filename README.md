# 🎭 Costume Scheduler

A lightweight web-based scheduling tool for theater wardrobe departments.

## Features
- 🗓️ **Schedule Management** – Assign costumes and dressers to actors at specific times
- 📊 **Gantt & Timeline Views** – Visual overview of dressing events with conflict detection
- 🛠️ **Inventory Editor** – Complete wardrobe management system
- 📄 **Reporting System** – Generate detailed reports for inventory and scheduling
- 🧪 **Live JSON Viewer** – Inspect the full API payload in the browser
- 🧼 **Portable, Airgapped Friendly** – No external dependencies, runs locally on Flask

## Quick Start

### 1. Clone Repository
```bash
git clone https://github.com/your-username/costume-scheduler.git
cd costume-scheduler
```

### 2. Create Virtual Environment
```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### 3. Install Dependencies
```bash
pip install -r backend/requirements.txt
```

### 4. Run the Application
```bash
python backend/app.py
```

### 5. Access in Browser
Open [http://127.0.0.1:5000](http://127.0.0.1:5000) in your web browser

## Directory Structure
```
my_wardrobe/
├── backend/              # Flask backend
│   └── app.py            # Main application server
├── frontend/             # Frontend files
│   ├── templates/        # HTML templates
│   │   ├── feature/      # Stable feature pages
│   │   └── test/         # Development pages
│   └── static/           # Static assets
│       ├── css/          # Stylesheets
│       └── js/           # JavaScript files
├── data/                 # JSON data storage
├── logs/                 # Frontend check logs
├── patches/              # Version patches
│   └── v0.x.x/           # Versioned patches
├── pdf_imports/          # For PDF inventory imports
├── pdf_conversions/      # CSV output from PDF conversion
├── version.json          # Version tracking
├── check_frontend.sh     # Route testing utility
├── check_frontend_enhanced.sh  # Enhanced testing script
├── git-manager.sh        # Git repository management
├── pdf_to_csv.py         # PDF to CSV converter
└── feature_setup.sh      # Template setup script
```

## Main Features and Routes

### Dashboard and Reports
- **Dashboard** (`/`, `/dashboard`) – Overview of system with latest data
- **Reports** (`/reports`) – Generate and export reports

### Scheduling Views
- **Gantt Chart** (`/gantt`) – Schedule visualization as Gantt chart
- **Extended View** (`/extended`) – Detailed timeline with conflict detection

### Inventory Management
- **Wardrobe Editor** (`/editor`) – Full inventory management interface

### Development Tools
- **Experimental Dashboard** (`/test/dashboard`) – Dashboard with side menu
- **Git Manager** (`/git-manager`) – Git repository management interface
- **Legacy View** (`/legacy`) – Original interface

## API Reference

### Endpoints
- `GET /api/data` – Retrieve all application data
- `POST /api/update` – Update application data
- `POST /api/upload` – Upload JSON data
- `GET /api/download` – Download JSON data as file

### Data Format
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
      "category": "",
      "size": "",
      "status": "",
      "price": 0,
      "location": "",
      "condition": ""
    }
  ],
  "version": "v0.4.0"
}
```

## Utilities

### Testing and Verification
Run the enhanced frontend check to verify all routes:
```bash
./check_frontend_enhanced.sh
```

### PDF Inventory Import
Convert PDF inventory files to CSV format:
```bash
# 1. Place PDF files in pdf_imports/ directory
# 2. Run conversion script
python pdf_to_csv.py
# 3. CSV files will be generated in pdf_conversions/ directory
```

### Git Management
Use the Git Manager to handle branches, versioning, and conflict resolution:
```bash
./git-manager.sh
```

## Versioning
Current version: v0.4.0

Check the detailed changelog in `changelog.md` for version history and updates.

## Development Notes
- This application uses Flask's built-in development server. For production, use a proper WSGI server.
- The repository includes a patching system for version control.
- All JavaScript is vanilla JS with no external dependencies required.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
