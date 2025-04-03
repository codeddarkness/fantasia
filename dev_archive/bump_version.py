import json

VERSION_FILE = "version.json"

def bump_version(part="patch"):
    with open(VERSION_FILE, "r+") as f:
        versions = json.load(f)
        current = versions.get("backend", "0.1.0")
        major, minor, patch = map(int, current.split("."))

        if part == "major":
            major += 1
            minor = patch = 0
        elif part == "minor":
            minor += 1
            patch = 0
        else:
            patch += 1

        new_version = f"{major}.{minor}.{patch}"
        versions["backend"] = new_version
        versions["frontend"] = new_version
        f.seek(0)
        json.dump(versions, f, indent=2)
        f.truncate()

    print(f"✅ Bumped to version {new_version}")

if __name__ == "__main__":
    import sys
    bump_version(sys.argv[1] if len(sys.argv) > 1 else "patch")

