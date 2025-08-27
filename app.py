from main import load_metta_file, execute_query
from flask import Flask, request, jsonify
import subprocess

app = Flask(__name__)

#checking if Flask works
@app.route("/")
def hello():
    return "Hello, Flask is working!"


#routes
@app.route("/recommend/<user_id>", methods=["GET"])
def recommendByGenre(user_id):
    query = f"!(recommend {user_id})"
    result1 = execute_query(query)
    return jsonify({"user" : user_id, "recommendations": result1})


@app.route("/recommendByDirector/<user_id>", methods=["GET"])
def recommendByDirector(user_id):
    query = f"!(recommendByDirector {user_id})"
    result2 = execute_query(query)
    return jsonify({"user" : user_id, "recommendations": result2})


@app.route("/recommendByCollaboration/<user_id>", methods=["GET"])
def recommendByCollab(user_id):
    query = f"!(recommendByCollaboration {user_id})"
    result3 = execute_query(query)
    return jsonify({"user" : user_id, "recommendations": result3})


@app.route("/query", methods=["POST"])
def userInput():

    data = request.get_json()
    query_text = data.get("query")

    if not query_text:
        return jsonify({"error": "No input provided"}), 400
    
    results = execute_query(query_text)
    return jsonify({"results": results})






if __name__ == "__main__":
    app.run(debug=True)