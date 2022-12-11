import logging
import os


def setup_logger():
    logging.basicConfig(
        level=(
            logging.DEBUG
            if int(os.environ.get("DEBUG", "0")) > 0
            else logging.INFO
        ),
        datefmt="%y%m%d %H:%M:%S",
        format="[%(levelname)s %(asctime)s %(module)s:%(lineno)d] %(message)s",
    )
