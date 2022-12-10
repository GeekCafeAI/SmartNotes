import dramatiq
import time
from src.datastore.datastore import Datastore

DB_URL = "sqlite:///SmartNotes.db" # Move to ENV vars
datastore = Datastore(DB_URL)

@dramatiq.actor(
    queue_name="get-tags", max_retries=0, time_limit=10_800_000
)
def get_tags(request_id, text):
    print("started")
    datastore.start_text_tagging(request_id)
    time.sleep(1)
    result = text.split(" ")[:5]
    datastore.complete_text_tagging(request_id,result)
    print("finished")