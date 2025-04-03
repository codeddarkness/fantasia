from flask import Flask, render_template, request, jsonify, send_file
import json, os, socket, subprocess, time, sys

VERSION_FILE = os.path.join(os.path.dirname(__file__), "../version.json")
DATA_FILE = os.path.join(os.path.dirname(__file__), "../data/costume_shop.json")
TEMPLATE_DIR = os.path.join(os.path.dirname(__file__), "../frontend/templates")
STATIC_DIR = os.path.join(os.path.dirname(__file__), "../frontend/static")

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

def load_versions():
    try:
        with open(VERSION_FILE) as f:
            v = json.load(f)
            return v.get("backend", "?"), v.get("frontend", "?")
    except:
        return "unknown", "unknown"

app = Flask(__name__, template_folder=TEMPLATE_DIR, static_folder=STATIC_DIR)

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/api/data")
def get_data():
    with open(DATA_FILE) as f:
        data = json.load(f)
    backend_v, frontend_v = load_versions()
    data["version"] = backend_v
    return jsonify(data)

@app.route("/api/update", methods=["POST"])
def update_data():
    with open(DATA_FILE, "w") as f:
        json.dump(request.json, f, indent=2)
    return jsonify({"status": "ok"})

@app.route("/api/download")
def download_json():
    return send_file(DATA_FILE, as_attachment=True)

@app.route("/api/upload", methods=["POST"])
def upload_json():
    with open(DATA_FILE, "w") as f:
        json.dump(request.json, f, indent=2)
    return jsonify({"status": "uploaded"})

def restart_on_port_kill(port):
    print("✅ Process killed. Restarting server...")
    time.sleep(1)
    os.execv(sys.executable, [sys.executable] + sys.argv)

if __name__ == "__main__":
    backend_v, frontend_v = load_versions()
    PORT = 5000

    print(f"\n🧵 Costume Scheduler – Backend: v{backend_v}, Frontend: v{frontend_v}")
    print(f"🌐 Open in browser: http://127.0.0.1:{PORT}")
    print("🔒 If you're getting 400/SSL errors, make sure you’re using HTTP, not HTTPS!")

    if check_port(PORT):
        print(f"\n⚠️ Port {PORT} is already in use.")
        pid = find_pid_using_port(PORT)
        if pid:
            print(f"🔍 PID using port {PORT}: {pid}")
            confirm = input(f"Do you want to kill process {pid} and continue? (y/n): ").strip().lower()
            if confirm == 'y':
                os.system(f"kill {pid}")
                restart_on_port_kill(PORT)
            else:
                alt = input("Enter an alternate port (e.g. 5050): ").strip()
                if alt.isdigit():
                    PORT = int(alt)
        else:
            alt = input("Could not auto-detect the process. Enter a different port to use: ").strip()
            if alt.isdigit():
                PORT = int(alt)

        print(f"🌐 Open in browser: http://127.0.0.1:{PORT}")
        print("🔒 If you're getting 400/SSL errors, make sure you’re using HTTP, not HTTPS!")

    app.run(debug=True, host="0.0.0.0", port=PORT)

