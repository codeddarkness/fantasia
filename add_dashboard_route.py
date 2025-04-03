#!/usr/bin/env python3
import os

def add_routes_to_app():
    app_file = "backend/app.py"

    # Read the current content
    with open(app_file, "r") as f:
        content = f.read()

    # Create the routes to add
    routes_to_add = """
@app.route('/dashboard')
def dashboard():
    return render_template('dashboard.html')
"""

    # Find if there are any missing routes
    missing_routes = []

    if "@app.route('/dashboard')" not in content:
        missing_routes.append("/dashboard")

    if not missing_routes:
        print("✅ All routes already exist in app.py")
        return

    # Insert the routes
    if "if __name__ == \"__main__\"" in content:
        content = content.replace("if __name__ == \"__main__\"", routes_to_add + "\nif __name__ == \"__main__\"")

        # Write back to the file
        with open(app_file, "w") as f:
            f.write(content)

        print(f"✅ Added routes to app.py: {', '.join(missing_routes)}")
    else:
        print("❌ Could not find the right position to insert the routes")
        print("Please manually add the following to your app.py file:")
        print(routes_to_add)

if __name__ == "__main__":
    add_routes_to_app()
