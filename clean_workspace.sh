#!/bin/bash
mkdir -p dev_archive

# Move helper scripts
mv apply_patch*.sh dev_archive/ 2>/dev/null
mv run_patch*.sh dev_archive/ 2>/dev/null
mv create_patch_readme.sh dev_archive/ 2>/dev/null
mv make_patch.py dev_archive/ 2>/dev/null
mv bump_version.py dev_archive/ 2>/dev/null
mv check_frontend.sh dev_archive/ 2>/dev/null
mv init_costume_project.py dev_archive/ 2>/dev/null
mv archive_project.py dev_archive/ 2>/dev/null
mv clean_inventory.py dev_archive/ 2>/dev/null

echo "✅ Development helper scripts moved to ./dev_archive/"

