import os
import shutil
import json

PATCHES_DIR = "patches"
VERSION_FILE = "version.json"

def apply_patch(version):
    patch_path = os.path.join(PATCHES_DIR, version)
    if not os.path.isdir(patch_path):
        print(f"❌ Patch '{version}' not found in patches/")
        return

    # Apply patch
    for root, _, files in os.walk(patch_path):
        for f in files:
            rel_dir = os.path.relpath(root, patch_path)
            target_dir = os.path.join(os.getcwd(), rel_dir)
            os.makedirs(target_dir, exist_ok=True)
            shutil.copy2(os.path.join(root, f), os.path.join(target_dir, f))
            print(f"✅ Updated {os.path.join(rel_dir, f)}")

    # Update version file
    if os.path.exists(VERSION_FILE):
        with open(VERSION_FILE, "r+") as vf:
            data = json.load(vf)
            data["backend"] = version
            data["frontend"] = version
            vf.seek(0)
            json.dump(data, vf, indent=2)
            vf.truncate()
        print(f"📝 Updated version.json to {version}")
    else:
        print("⚠️ version.json not found.")

if __name__ == "__main__":
    version = input("Enter patch version to apply (e.g., v0.2.0): ").strip()
    apply_patch(version)

