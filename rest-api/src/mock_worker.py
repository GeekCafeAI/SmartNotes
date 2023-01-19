import logging
import time

from src.datastore.datastore import Datastore
from src.gpt3 import get_tags_and_date
from src.utils import setup_logger

DB_URL = "sqlite:///../../../SmartNotes.db"  # TODO: move to postgre, store path in ENV vars
datastore = Datastore(DB_URL)

setup_logger()
logger = logging.getLogger(__name__)


# import dramatiq
# @dramatiq.actor(queue_name="get-tags", max_retries=0, time_limit=10_800_000)
# def get_tags(request_id, text):
#     logger.info("Started calculation")
#     datastore.start_text_tagging(request_id)
#     time.sleep(1)
#     result = " ".join(text.split(" ")[:5])  # TODO: change to list
#     datastore.complete_text_tagging(request_id, result)
#     logger.info("Finished calculation")


def get_tags_sync(
    datastore: Datastore, request_id: int, user_id: str, text: str
):
    logger.info("Started calculation")
    datastore.start_note_tagging(request_id, user_id)

    record = get_tags_and_date(text)
    tags = record["tags"]
    result = ",".join(tags)
    ####

    datastore.complete_note_tagging(request_id, user_id, result)
    logger.info("Finished calculation")
    return result
