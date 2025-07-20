from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route("/")
def index():
    return jsonify({"status": "AIS Core API Running"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)