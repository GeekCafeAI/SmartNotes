from typing import List, Optional, TYPE_CHECKING

if TYPE_CHECKING:
    from .datastore import HasEngineProtocol
else:
    class HasEngineProtocol: ...

import enum
import sqlalchemy as sa
from datetime import datetime
from sqlalchemy.orm import Session, Mapped, mapped_column
from datetime import datetime, timezone
from src.datastore.base_model import BaseTable

class TagStatus(str, enum.Enum):
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"

class TaggedText(BaseTable):
    __tablename__ = "tagged_text"

    id: Mapped[int] = mapped_column(primary_key=True)
    status: Mapped[TagStatus]
    text: Mapped[str]
    tags: Mapped[Optional[str]] #TODO: add separate table for tags, make it list
    created_at: Mapped[datetime] = mapped_column(sa.TIMESTAMP(timezone=True), nullable=False)
    updated_at: Mapped[datetime] = mapped_column(sa.TIMESTAMP(timezone=True), nullable=True)

class TaggedTextMixin(HasEngineProtocol):
    def get_text_tagging(self,id:int) -> Optional[TaggedText]: 
        with Session(self.engine) as session:
            tagged_text: TaggedText = session.get(TaggedText,id)
            if tagged_text is not None:
                return tagged_text.to_dict()
        return None

    def create_text_tagging(self,text:str) -> TaggedText:        
        dt_now = datetime.now(tz=timezone.utc)
        tagged_text = TaggedText(
            created_at = dt_now,
            updated_at = dt_now,
            text = text,
            status = TagStatus.PENDING
        )

        dict_result = None
        with Session(self.engine) as session:
            session.add(tagged_text)
            session.commit()
            dict_result = tagged_text.to_dict()
        return dict_result

    def start_text_tagging(self,id:int) -> Optional[TaggedText]:        
        dt_now = datetime.now(tz=timezone.utc)
        tagged_text = None
        with Session(self.engine) as session:
            tagged_text: TaggedText = session.get(TaggedText,id)
            if tagged_text is not None:
                tagged_text.status = TagStatus.IN_PROGRESS
                tagged_text.updated_at = dt_now 
                session.commit()
                tagged_text = tagged_text.to_dict()
        return tagged_text  

    def complete_text_tagging(self,id:int,tags:str) -> Optional[TaggedText]:        
        dt_now = datetime.now(tz=timezone.utc)
        tagged_text = None
        with Session(self.engine) as session:
            tagged_text: TaggedText = session.get(TaggedText,id)
            if tagged_text is not None:
                tagged_text.status = TagStatus.COMPLETED
                tagged_text.updated_at = dt_now
                tagged_text.tags = tags
                session.commit()
                tagged_text = tagged_text.to_dict()
        return tagged_text