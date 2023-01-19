import logging
from typing import List, Optional

from flask import Flask, jsonify, render_template, request
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


def bad_request(
    message: Optional[str] = None,
    missing_args: Optional[List[str]] = None,
    status_code=404,
):
    send_message = ""
    if missing_args:
        send_message = f"Required arguments {missing_args} are empty!"
    if message:
        send_message += f" {message}"
    response = jsonify({"message": send_message})
    response.status_code = status_code
    return response


def get_request_data(args_list: List[str]):
    data = {}
    if request.content_type and request.content_type.startswith(
        "application/json"
    ):
        data = request.get_json()
    else:
        data = request.args.to_dict()
    logger.info(data)
    missing_args = []
    for arg in args_list:
        if arg not in data:
            missing_args.append(arg)
    return data, missing_args


@app.route("/")
def index():
    return render_template("index.html")


@app.get("/notes")
def notes_get():
    data, missing_args = get_request_data(["user_id"])
    if missing_args:
        return bad_request(missing_args=missing_args)

    if "id" in data:
        note = datastore.get_note(data["id"], data["user_id"])
        if note is None:
            return bad_request(f"No note found by parameters: {data}")

        return {
            "message": "Successfully retrieved note!",
            "note": note.to_dict(),
        }
    else:
        all_notes = datastore.get_all_notes(data["user_id"])
        return {
            "message": "Successfully retrieved notes!",
            "notes": [note_to_response(t) for t in all_notes],
        }


@app.put("/notes")
def notes_put():
    data, missing_args = get_request_data(["id", "user_id"])

    if missing_args:
        return bad_request(missing_args=missing_args)

    note = datastore.edit_note(data["id"], data["user_id"], data)
    if note is None:
        return bad_request(f"Cannot update note with requested parameters")

    response_note = note_to_response(note)

    return {"message": "Successfully updated note!", "note": response_note}


@app.post("/notes")
def notes_post():
    data, missing_args = get_request_data(["text", "user_id"])
    if missing_args:
        return bad_request(missing_args=missing_args)

    note = datastore.create_note(data["text"], data["user_id"])

    # TODO: Look inside
    get_tags_sync(datastore, note.id, data["user_id"], data["text"])

    note = datastore.get_note(note.id, data["user_id"])

    response_note = note_to_response(note)

    ## Uncomment for message queue
    # get_tags.send(
    #     tagged_text.id, data_json["text"]
    # )  # Start as a background task
    # return {
    #     "message": "Successfully started calculation",
    #     "id": tagged_text.id,
    # }

    return {"message": "Successfully created note!", "note": response_note}


@app.delete("/notes")
def notes_delete():
    data, missing_args = get_request_data(["id", "user_id"])

    if missing_args:
        return bad_request(missing_args=missing_args)

    note = datastore.delete_note(data["id"], data["user_id"])
    if note is None:
        return bad_request(f"Cannot delete note with requested parameters")

    response_note = note_to_response(note)

    return {"message": "Successfully deleted note!", "note": response_note}


def note_to_response(note):
    result = note.to_dict()
    result.tags = result.tags.split(",")
    return result
