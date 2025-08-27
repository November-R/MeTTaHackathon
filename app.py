from flask import Flask, request, jsonify
import subprocess

app = Flask(__name__)

#checking if Flask works
@app.route("/")
def hello():
    return "Hello, Flask is working!"


if __name__ == "__main__":
    app.run(debug=True)