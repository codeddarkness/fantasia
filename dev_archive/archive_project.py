import os
import shutil
from datetime import datetime

def archive_project(tag=None):
    now = datetime.now().strftime("%Y%m%d_%H%M%S")
    version = f"{now}_{tag}" if tag else now
    archive_folder = f"archive/{version}"
    os.makedirs(archive_folder, exist_ok=True)

    for folder in ["backend", "frontend", "data", "version.json"]:
        if os.path.exists(folder):
            shutil.copytree(folder, f"{archive_folder}/{folder}") if os.path.isdir(folder) else shutil.copy2(folder, archive_folder)

    print(f"✅ Project archived as: {archive_folder}")

if __name__ == "__main__":
    tag = input("Optional tag for this archive version (e.g. gantt_ui): ").strip()
    archive_project(tag)

