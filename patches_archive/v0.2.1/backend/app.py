from flask import Flask, render_template, request, jsonify
import json
from datetime import datetime
import socket
import subprocess
import os
app = Flask(__name__,
            template_folder=os.path.join(os.path.dirname(__file__), '../frontend/templates'),
            static_folder=os.path.join(os.path.dirname(__file__), '../frontend/static'))



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

if __name__ == "__main__":
    PORT = 5000

    if check_port(PORT):
        print(f"⚠️ Port {PORT} is already in use.")

        pid = find_pid_using_port(PORT)
        if pid:
            print(f"🔍 PID using port {PORT}: {pid}")
            confirm = input(f"Do you want to kill process {pid} and continue? (y/n): ").strip().lower()
            if confirm == 'y':
                os.system(f"kill {pid}")
                print("✅ Killed. Starting Flask...")
            else:
                alt = input("Enter an alternate port (e.g. 5050): ").strip()
                PORT = int(alt)
        else:
            alt = input("Could not auto-detect the process. Enter a different port to use: ").strip()
            PORT = int(alt)

    app.run(debug=True, host="0.0.0.0", port=PORT)



DB_FILE = "data/costume_shop.json"

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/api/data")
def get_data():
    with open(DB_FILE, "r") as f:
        return jsonify(json.load(f))

@app.route("/api/update", methods=["POST"])
def update_data():
    new_data = request.json
    with open(DB_FILE, "w") as f:
        json.dump(new_data, f, indent=2)
    return {"status": "ok"}

#################
@app.route("/api/download")
def download_data():
    return app.response_class(
        response=open(DB_FILE).read(),
        mimetype='application/json',
        headers={"Content-Disposition": "attachment;filename=costume_shop.json"}
    )

@app.route("/api/upload", methods=["POST"])
def upload_data():
    new_data = request.get_json()
    with open(DB_FILE, "w") as f:
        json.dump(new_data, f, indent=2)
    return {"status": "uploaded"}


################

#if __name__ == "__main__":
#    app.run(debug=True)

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)

