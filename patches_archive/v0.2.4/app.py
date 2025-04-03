# backend/app.py
from flask import Flask, render_template, request, jsonify, send_file
import json
from datetime import datetime
import socket
import subprocess
import os

# Load version
with open("version.json") as f:
    version = json.load(f)
backend_version = version.get("backend", "unknown")
frontend_version = version.get("frontend", "unknown")

print(f"\n\U0001F9F5 Costume Scheduler – Backend: {backend_version}, Frontend: {frontend_version}")

# Flask app setup
app = Flask(
    __name__,
    template_folder=os.path.join(os.path.dirname(__file__), '../frontend/templates'),
    static_folder=os.path.join(os.path.dirname(__file__), '../frontend/static')
)

def check_port(port):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        return s.connect_ex(("localhost", port)) == 0

def find_pid_using_port(port):
    try:
        output = subprocess.check_output(["lsof", "-i", f":{port}"]).decode()
        for line in output.splitlines()[1:]:
            parts = line.split()
            if len(parts) >= 2:
                return int(parts[1])
    except subprocess.CalledProcessError:
        pass
    return None

def run_server(port):
    print(f"\U0001F310 Open in browser: http://127.0.0.1:{port}")
    print("\U0001F512 If you're getting 400/SSL errors, make sure you’re using HTTP, not HTTPS!\n")
    app.run(debug=True, host="0.0.0.0", port=port)

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/api/data")
def get_data():
    with open("data/costume_shop.json") as f:
        return jsonify(json.load(f))

@app.route("/api/update", methods=["POST"])
def update_data():
    with open("data/costume_shop.json", "w") as f:
        json.dump(request.json, f, indent=2)
    return '', 204

@app.route("/api/upload", methods=["POST"])
def upload_data():
    with open("data/costume_shop.json", "w") as f:
        json.dump(request.json, f, indent=2)
    return '', 204

@app.route("/api/download")
def download_json():
    return send_file("data/costume_shop.json", as_attachment=True)

if __name__ == "__main__":
    PORT = 5000
    if check_port(PORT):
        print(f"\u26a0\ufe0f Port {PORT} is already in use.")
        pid = find_pid_using_port(PORT)
        if pid:
            print(f"\U0001f50d PID using port {PORT}: {pid}")
            confirm = input(f"Do you want to kill process {pid} and continue? (y/n): ").strip().lower()
            if confirm == 'y':
                os.system(f"kill {pid}")
                print("\u2705 Killed. Restart the app to continue.")
                exit()
            else:
                alt = input("Enter an alternate port (e.g. 5050): ").strip()
                PORT = int(alt)
        else:
            alt = input("Could not auto-detect the process. Enter a different port to use: ").strip()
            PORT = int(alt)
    run_server(PORT)

