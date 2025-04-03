#!/usr/bin/env python3
import os

def add_route_to_app():
    app_file = "backend/app.py"
    
    # Read the current content
    with open(app_file, "r") as f:
        content = f.read()
    
    # Check if the route already exists
    if "@app.route('/test/extended')" in content:
        print("✅ Extended overlap route already exists")
        return
    
    # Find the position to insert - before if __name__ 
    new_route = """
@app.route('/test/extended')
def test_extended():
    return render_template('test/extended_overlap.html')
"""
    
    # Insert the route
    if "if __name__ == \"__main__\"" in content:
        content = content.replace("if __name__ == \"__main__\"", new_route + "\nif __name__ == \"__main__\"")
        
        # Write back to the file
        with open(app_file, "w") as f:
            f.write(content)
        
        print("✅ Added extended overlap route to app.py")
    else:
        print("❌ Could not find the right position to insert the route")
        print("Please manually add the following to your app.py file:")
        print(new_route)

if __name__ == "__main__":
    add_route_to_app()
