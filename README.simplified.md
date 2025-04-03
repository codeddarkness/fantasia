# Costume Scheduler

A lightweight browser-based app for managing wardrobe logistics for theater productions.

## Features

- 📅 Schedule dressing times by actor, dresser, and wardrobe item
- 📊 Visual Gantt chart with debug JSON panel
- 🔹 Tasks with deadlines, wardrobe inventory management
- 💡 Designed for airgapped or offline use

## Getting Started

### 1. Install dependencies
python3 -m venv venv
source venv/bin/activate
pip install flask

### 2. Run the server
python3 backend/app.py

Then visit http://127.0.0.1:5000

### 3. Load demo data (optional)
cp data/scheduler_data_demo.json data/scheduler_data.json

## Simplified Patching System

The project includes a simplified patch management tool:

# Apply a patch
./patch_manager.sh apply v0.3.2

# Create a new patch with specific files
./patch_manager.sh create backend/app.py frontend/static/js/script.js

# List available patches
./patch_manager.sh list

# Clean up old patches
./patch_manager.sh clean

## Data Format

The app uses a JSON structure with:
- agents: Lists of actors, dressers, and managers
- schedules: Assignments of actors, dressers and items at specific times
- tasks: Tasks with deadlines and assignments
- wardrobe_items: Inventory of costume pieces

## Troubleshooting

- If port 5000 is already in use, the app will prompt for an alternative
- Make sure to use HTTP not HTTPS when accessing locally
- Check logs folder for debug information
