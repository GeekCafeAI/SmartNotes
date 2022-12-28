import logging
import os
from typing import Optional, Protocol, Tuple
from urllib.parse import urlparse

from sqlalchemy import create_engine
from sqlalchemy.engine import Engine
from src.datastore.base_model import BaseTable
from src.datastore.note import NoteMixin

logger = logging.getLogger(__name__)


class HasEngineProtocol(Protocol):
    @property
    def engine(self) -> Engine:
        ...


class Datastore(NoteMixin):
    """
    Datastore that requires a database URL.
    """

    def __init__(
        self,
        database_url: str = None,
        echo: bool = False,
        profile_queries: bool = False,
        pool_size: int = 5,
    ):

        self.database_url = database_url
        self.echo = echo
        self.profile_queries = profile_queries
        self.pool_size = pool_size
        if self.database_url is None:
            self.database_url = os.environ.get("DB_URL", None)
        if self.database_url is None:
            self.database_url = os.environ.get("DATABASE_URL", None)
        if self.database_url is None:
            raise EnvironmentError(
                "No database_url kwarg provided. Fallback expected to find "
                "DB_URL or DATABASE_URL in environment, but neither are "
                "present. Database connection cannot be created."
            )

        self._engine: Optional[Engine] = None

    @property
    def engine(self) -> Engine:
        if self._engine is None:

            db_url_parts = urlparse(self.database_url)
            logger.info(
                f"Setting up connection pool "
                f"for DB host: {db_url_parts.hostname}"
            )

            # use a SQLA2 compatible engine
            self._engine = create_engine(
                self.database_url,
                echo=self.echo,
                future=True,
                pool_size=self.pool_size,
                pool_pre_ping=True,
            )
            logger.info(
                f"Initialized connection pool of size {self.pool_size}."
            )
        return self._engine

    def create_all_tables(self):
        BaseTable.metadata.create_all(self.engine)
