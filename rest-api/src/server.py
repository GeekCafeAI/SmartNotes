from flask import Flask, jsonify,request
from src.datastore import Datastore

# create the app
app = Flask(__name__)

DB_URL = "sqlite:///SmartNotes.db"
datastore = Datastore(DB_URL)

def bad_request(message,status_code=404):
    response = jsonify({'message': message})
    response.status_code = status_code
    return response

@app.get('/classify')
def classify_get():
    request_id = request.args.get('id', default = None, type = int)
    if request_id is None:
        return bad_request("'id' is required!")
    
    tagged_text = datastore.get_text_tagging(request_id)
    if tagged_text is None:
        return bad_request(f"No request found by id: {request_id}")
    
    return tagged_text


@app.post('/classify')
def classify_post():
    data_json = request.get_json()
    if "text" not in data_json:
        return bad_request("'text' is required!")
    
    tagged_text = datastore.create_text_tagging(data_json['text'])

    return {
        'message': "Successfully started calculation",
        "id":tagged_text["id"]
    }

