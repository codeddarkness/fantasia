from flask import Flask, render_template, request, jsonify, send_file
from datetime import datetime
import socket
import subprocess
import os
import json
import time

VERSION_FILE = os.path.join(os.path.dirname(__file__), '../version.json')
with open(VERSION_FILE) as f:
    version_data = json.load(f)

BACKEND_VERSION = version_data["backend"].lstrip("v")
FRONTEND_VERSION = version_data["frontend"].lstrip("v")

app = Flask(__name__,
            template_folder=os.path.join(os.path.dirname(__file__), '../frontend/templates'),
            static_folder=os.path.join(os.path.dirname(__file__), '../frontend/static'))

DATA_FILE = os.path.join(os.path.dirname(__file__), '../data/data.json')

def check_port(port):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        return s.connect_ex(("localhost", port)) == 0

def find_pid_using_port(port):
    try:
        output = subprocess.check_output(["lsof", "-i", f":{port}"]).decode()
        for line in output.splitlines()[1:]:
            parts = line.split()
            if len(parts) >= 2:
                return int(parts[1])  # PID
    except subprocess.CalledProcessError:
        pass
    return None

def read_data():
    try:
        with open(DATA_FILE, 'r') as f:
            return json.load(f)
    except Exception:
        return {
            "agents": {"actors": [], "dressers": [], "managers": []},
            "wardrobe_items": [],
            "schedules": [],
            "tasks": [],
            "version": f"v{BACKEND_VERSION}"
        }

def write_data(data):
    with open(DATA_FILE, 'w') as f:
        json.dump(data, f, indent=2)

# Main routes
@app.route('/')
def index():
    return render_template('dashboard_new.html')

@app.route('/dashboard')
def dashboard():
    return render_template('dashboard_new.html')

@app.route('/legacy')
def legacy():
    return render_template('index.html')

@app.route('/legacy-dashboard')
def legacy_dashboard():
    return render_template('dashboard.html')

# API routes
@app.route('/api/data')
def api_data():
    return jsonify(read_data())

@app.route('/api/update', methods=['POST'])
def api_update():
    write_data(request.json)
    return jsonify({"status": "ok"})

@app.route('/api/upload', methods=['POST'])
def api_upload():
    try:
        new_data = request.json
        write_data(new_data)
        return jsonify({"status": "uploaded"})
    except Exception:
        return jsonify({"status": "error"}), 400

@app.route('/api/download')
def api_download():
    return send_file(DATA_FILE, as_attachment=True)

# Feature routes (direct routes without /feature/ prefix)
@app.route('/gantt')
def gantt():
    return render_template('feature/gantt.html')

@app.route('/extended')
def extended():
    return render_template('feature/extended_overlap.html')

@app.route('/editor')
def editor():
    return render_template('feature/wardrobe_editor.html')

@app.route('/reports')
def reports():
    return render_template('feature/reports.html')

# Legacy test routes (keeping for backward compatibility)
@app.route('/test/gantt')
def test_gantt():
    # Redirect to the new route
    return render_template('feature/gantt.html')

@app.route('/test/extended')
def test_extended():
    # Redirect to the new route
    return render_template('feature/extended_overlap.html')

@app.route('/test/editor')
def test_editor():
    # Redirect to the new route
    return render_template('feature/wardrobe_editor.html')

@app.route('/test/dashboard')
def test_dashboard():
    # Now this just points to the main dashboard
    return render_template('dashboard_new.html')

if __name__ == "__main__":
    PORT = 5000

    print(f"\n🧵 Costume Scheduler – Backend: v{BACKEND_VERSION}, Frontend: v{FRONTEND_VERSION}")
    print(f"🌐 Open in browser: http://127.0.0.1:{PORT}")
    print("🔒 If you're getting 400/SSL errors, make sure you're using HTTP, not HTTPS!\n")

    if check_port(PORT):
        print(f"⚠️ Port {PORT} is already in use.")
        pid = find_pid_using_port(PORT)
        if pid:
            print(f"🔍 PID using port {PORT}: {pid}")
            confirm = input(f"Do you want to kill process {pid} and continue? (y/n): ").strip().lower()
            if confirm == 'y':
                try:
                    os.kill(pid, 9)
                    print("✅ Killed. Restarting Flask...")
                    time.sleep(1)
                except Exception as e:
                    print(f"❌ Failed to kill process: {e}")
                    exit(1)
            else:
                alt = input("Enter an alternate port (e.g. 5050): ").strip()
                if not alt.isdigit():
                    print("Invalid port. Exiting.")
                    exit(1)
                PORT = int(alt)
                print(f"🌐 Open in browser: http://127.0.0.1:{PORT}")
        else:
            alt = input("Could not auto-detect the process. Enter a different port to use: ").strip()
            if not alt.isdigit():
                print("Invalid port. Exiting.")
                exit(1)
            PORT = int(alt)
            print(f"🌐 Open in browser: http://127.0.0.1:{PORT}")

    app.run(debug=True, host="0.0.0.0", port=PORT, use_reloader=False)
