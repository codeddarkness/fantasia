from flask import Flask, render_template, request, jsonify
import json
from datetime import datetime

import os
app = Flask(__name__,
            template_folder=os.path.join(os.path.dirname(__file__), '../frontend/templates'),
            static_folder=os.path.join(os.path.dirname(__file__), '../frontend/static'))


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

if __name__ == "__main__":
    app.run(debug=True)
