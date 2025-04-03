import os
import shutil
import sys
from datetime import datetime

SOURCE_DIRS = ["backend", "frontend"]
PATCHES_DIR = "patches"

def copy_file(src, dst):
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    shutil.copy2(src, dst)

def make_patch(version, files):
    patch_path = os.path.join(PATCHES_DIR, version)
    if os.path.exists(patch_path):
        print(f"❌ Patch '{version}' already exists.")
        return

    copied_files = []
    for file in files:
        for src_root in SOURCE_DIRS:
            src_path = os.path.join(src_root, file)
            if os.path.exists(src_path):
                dst_path = os.path.join(patch_path, src_root, file)
                copy_file(src_path, dst_path)
                copied_files.append(f"{src_root}/{file}")
                print(f"✅ Added {src_root}/{file} to patch {version}")
                break
        else:
            print(f"⚠️ File not found: {file}")

    # Create README.md with heredoc-style formatting
    readme_path = os.path.join(patch_path, "README.md")
    with open(readme_path, "w") as f:
        f.write(f"# Patch {version}\n\n")
        f.write("### 🧠 Summary\n")
        f.write("TODO: Describe what this patch includes.\n\n")
        f.write("### 📁 Files Modified\n")
        for fpath in copied_files:
            f.write(f"- `{fpath}`\n")
        f.write(f"\n### 📅 Date\n{datetime.now().strftime('%Y-%m-%d')}\n\n")
        f.write("### ✅ How to Apply\n```bash\npython3 apply_patch.py\n# Enter: " + version + "\n```\n\n")
        f.write(f"### 🔁 Related Version\n- Updated `version.json` to `{version}`\n")

    print(f"📄 Created {readme_path}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 make_patch.py <version> <file1> <file2> ...")
        print("Example: python3 make_patch.py v0.2.2 app.py static/js/script.js")
        sys.exit(1)

    version = sys.argv[1]
    files = sys.argv[2:]
    make_patch(version, files)

