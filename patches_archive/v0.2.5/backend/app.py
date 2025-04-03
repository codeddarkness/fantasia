from flask import Flask, render_template, request, jsonify, send_file
import json
import os
import subprocess
import socket
from datetime import datetime

# -------------------- Config & Version --------------------
VERSION_FILE = os.path.join(os.path.dirname(__file__), '../version.json')
with open(VERSION_FILE) as vf:
    versions = json.load(vf)
BACKEND_VERSION = versions.get("backend", "unknown")
FRONTEND_VERSION = versions.get("frontend", "unknown")

# -------------------- Flask App Setup --------------------
app = Flask(
    __name__,
    template_folder=os.path.join(os.path.dirname(__file__), '../frontend/templates'),
    static_folder=os.path.join(os.path.dirname(__file__), '../frontend/static')
)

DATA_FILE = os.path.join(os.path.dirname(__file__), '../data/costume_shop.json')

# -------------------- Utility Functions --------------------
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

# -------------------- API Routes --------------------
@app.route("/")
def index():
    return render_template("index.html")

@app.route("/api/data")
def get_data():
    with open(DATA_FILE) as f:
        data = json.load(f)
        data['version'] = versions.get("frontend", "0.0.0")
        return jsonify(data)

@app.route("/api/update", methods=["POST"])
def update_data():
    content = request.json
    with open(DATA_FILE, "w") as f:
        json.dump(content, f, indent=2)
    return jsonify({"status": "ok"})

@app.route("/api/upload", methods=["POST"])
def upload():
    content = request.json
    with open(DATA_FILE, "w") as f:
        json.dump(content, f, indent=2)
    return jsonify({"status": "uploaded"})

@app.route("/api/download")
def download():
    return send_file(DATA_FILE, as_attachment=True)

# -------------------- Main Entry --------------------
if __name__ == "__main__":
    PORT = 5000

    print(f"\n\U0001F9F5 Costume Scheduler – Backend: {BACKEND_VERSION}, Frontend: {FRONTEND_VERSION}")
    print(f"\U0001F310 Open in browser: http://127.0.0.1:{PORT}")
    print("\U0001F512 If you're getting 400/SSL errors, make sure you’re using HTTP, not HTTPS!\n")

    if check_port(PORT):
        print(f"\u26A0\uFE0F Port {PORT} is already in use.")
        pid = find_pid_using_port(PORT)
        if pid:
            print(f"\U0001F50D PID using port {PORT}: {pid}")
            confirm = input(f"Do you want to kill process {pid} and continue? (y/n): ").strip().lower()
            if confirm == 'y':
                os.system(f"kill {pid}")
                print("✅ Killed. Restarting Flask...")
            else:
                alt = input("Enter an alternate port (e.g. 5050): ").strip()
                try:
                    PORT = int(alt)
                except:
                    print("Invalid port. Exiting.")
                    exit(1)
        else:
            alt = input("Could not auto-detect the process. Enter a different port to use: ").strip()
            try:
                PORT = int(alt)
            except:
                print("Invalid port. Exiting.")
                exit(1)

    print(f"\n\U0001F310 Open in browser: http://127.0.0.1:{PORT}")
    app.run(debug=True, host="0.0.0.0", port=PORT)

