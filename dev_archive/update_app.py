#!/usr/bin/env python3
import os

APP_PATH = "backend/app.py"
ROUTE_PATCH = "app_route_patch.py"

def add_route_to_app():
    with open(APP_PATH, "r") as f:
        content = f.read()
    
    with open(ROUTE_PATCH, "r") as f:
        patch = f.read()
    
    if "def test_gantt():" in content:
        print("✅ Route already exists in app.py")
        return
    
    # Find position to insert - before if __name__ == "__main__"
    if "if __name__ == \"__main__\"" in content:
        parts = content.split("if __name__ == \"__main__\"")
        new_content = parts[0] + "\n" + patch + "\n\nif __name__ == \"__main__\"" + parts[1]
        
        with open(APP_PATH, "w") as f:
            f.write(new_content)
        
        print("✅ Added test route to app.py")
    else:
        print("❌ Could not find the right position to insert the route")
        print("Please manually add the following to your app.py file:")
        print("="*40)
        print(patch)
        print("="*40)

if __name__ == "__main__":
    add_route_to_app()
