import logging

from flask import Flask, jsonify, request,render_template
from src.datastore import Datastore
from src.mock_worker import get_tags_sync
from src.utils import setup_logger

# create the app
app = Flask(__name__)

DB_URL = "sqlite:///SmartNotes.db"
datastore = Datastore(DB_URL)
datastore.create_all_tables()

setup_logger()
logger = logging.getLogger(__name__)


def bad_request(message, status_code=404):
    response = jsonify({"message": message})
    response.status_code = status_code
    return response

@app.route("/")
def index():    
    return render_template('index.html')


@app.get("/all")
def all_get():
    all_texts = datastore.get_all_texts()    
    return {
        "notes": [t.to_dict() for t in all_texts]
    }

@app.get("/classify")
def classify_get():
    request_id = request.args.get("id", default=None, type=int)
    if request_id is None:
        return bad_request("'id' is required!")

    tagged_text = datastore.get_text_tagging(request_id)
    if tagged_text is None:
        return bad_request(f"No request found by id: {request_id}")

    


@app.post("/classify")
def classify_post():
    data_json = request.get_json()
    if "text" not in data_json:
        return bad_request("'text' is required!")

    tagged_text = datastore.create_text_tagging(data_json["text"])
    
    # TODO: Look inside
    get_tags_sync(datastore, tagged_text.id,data_json["text"])

    tagged_text = datastore.get_text_tagging(tagged_text.id)
    
    ## Uncomment for message queue
    # get_tags.send(
    #     tagged_text.id, data_json["text"]
    # )  # Start as a background task
    # return {
    #     "message": "Successfully started calculation",
    #     "id": tagged_text.id,
    # }
    
    return tagged_text.to_dict()
