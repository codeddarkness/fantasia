🎭 Costume Scheduler – Project Summary & Export Notes
📁 Project Structure
plaintext
Copy
Edit
my_wardrobe/
├── backend/                 # Flask backend (app.py, APIs)
├── frontend/                # HTML templates and JS scripts
│   ├── templates/           # index.html and now test.html variants
│   └── static/
│       ├── css/
│       └── js/
├── data/                    # scheduler_data.json and demo files
├── logs/                    # debug logs and validation output
├── patches/                 # versioned patch trees v0.x.y/
├── updates/                 # staging area for new files to be patched
├── dev_archive/             # older utility/dev tools
├── version.json             # tracks current frontend/backend version
├── changelog.md             # manual changelog file
├── README.md                # project overview
├── apply_patch.sh           # master patch runner
├── prepare_patch.sh         # organizes files from updates/
└── new_data.sh              # injects or regenerates sample demo data
✅ Current Versions
Backend: v0.2.6

Frontend: v0.3.4

🔁 Patch System Overview
You are now using a fully automatic patching workflow that includes:

prepare_patch.sh:

Scans updates/ for any new or modified files

Detects embedded PATCH-PATH: headers in files

Moves files into the correct subfolder under patches/vX.Y.Z/

Warns if a file is missing version info

apply_patch.sh:

Reads the latest version folder in patches/

Copies files to appropriate destinations

Uses jq to update version.json

Supports frontend (static/js, templates), backend (app.py), and utility scripts

💡 Note: You no longer need to manually create a apply_patch_v0.x.y.sh script for each patch.

⚠️ Known Issues & WIP
🛠 Gantt Chart Rendering:

Was working in patch v0.2.6

Not visible since transition to v0.3.x

Likely caused by changes to script.js logic (attempted visual upgrades, debug panel injection)

A dedicated test page (test.html) and vis_gantt_preview.html have been added to facilitate iteration

⚙️ Incomplete Canvas Integration:

Attempts to download canvas zip from shared link failed (corrupt/non-ZIP format)

Canvas previews are manually extracted instead

🧪 Testing Utilities
check_frontend.sh: Validates /, /api/data, and JS asset loading

test.html: Local dual-view test frame comparing Gantt variants

new_data.sh: Generates valid extended test data and overwrites scheduler_data.json

vis_gantt_preview.html: Proof-of-concept for vis.js integration

🧹 Recommended Cleanup / Refactor Tasks
✅ Frontend Gantt Rendering
Fix broken chart rendering in script.js by porting stable logic from v0.2.6 and ensuring it works with new UI structure.

🧼 Script Consolidation

Remove old patcher variants (apply_patch_v0.x.y.sh)

Ensure only apply_patch.sh is used

🗃 Refactor Patch History

Archive or prune outdated patches in patches/

Consider checksum-based deduplication for clean history

📜 README Rewrite Ensure the README.md describes:

Setup

Data format

Patch system

Troubleshooting steps

🧪 Visual Testing Mode

Improve test.html to allow switching Gantt engines

Enable dynamic JS injection without reloading page

📤 Export & Git Support

Package with .zip or push to a Git repo

Add .gitattributes and .editorconfig for collaboration

🧩 Final Patch File (v0.3.4)
The last patch file (test.html) included this header:

html
Copy
Edit
<!-- PATCH-PATH: frontend/templates/test.html -->
This allowed prepare_patch.sh to detect it and move it into the correct patch version. Any files not using this header will be ignored.

If you're handing this off, just give the recipient the full project folder. With Python and jq installed, they can:

bash
Copy
Edit
bash prepare_patch.sh
bash apply_patch.sh
python3 backend/app.py
To launch the latest version.


