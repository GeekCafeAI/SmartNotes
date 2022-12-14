from typing import TYPE_CHECKING, Dict, List, Optional

if TYPE_CHECKING:
    from .datastore import HasEngineProtocol
else:
    class HasEngineProtocol:
        ...


import enum
from datetime import datetime, timezone

import sqlalchemy as sa
from sqlalchemy import select
from sqlalchemy.orm import Mapped, Session, mapped_column
from src.datastore.base_model import BaseTable


class ProcessStatus(str, enum.Enum):
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"


class Note(BaseTable):
    __tablename__ = "note"

    id: Mapped[int] = mapped_column(primary_key=True)
    user_id: Mapped[str] = mapped_column(index=True)
    status: Mapped[ProcessStatus]
    text: Mapped[str]
    tags: Mapped[
        Optional[str]
    ]  # TODO: add separate table for tags, make it list
    extracted_date: Mapped[Optional[datetime]] = mapped_column(
        sa.TIMESTAMP(timezone=True), nullable=True
    )
    created_at: Mapped[datetime] = mapped_column(
        sa.TIMESTAMP(timezone=True), nullable=False
    )
    updated_at: Mapped[Optional[datetime]] = mapped_column(
        sa.TIMESTAMP(timezone=True), nullable=True
    )


class NoteMixin(HasEngineProtocol):
    def get_all_notes(self,user_id:str) -> List[Note]:
        query = select(Note).where(Note.user_id == user_id)
        with Session(self.engine, expire_on_commit=False) as session:
            return session.scalars(query).all()
    
    def get_note(self, id: int,user_id:str) -> Optional[Note]:
        query = select(Note).where(Note.id == id, Note.user_id == user_id)
        with Session(self.engine, expire_on_commit=False) as session:
            note = session.scalars(query).first()            
        return note

    def create_note(self, text: str,user_id:str) -> Note:
        dt_now = datetime.now(tz=timezone.utc)
        note = Note(
            user_id=user_id,
            created_at=dt_now,
            updated_at=dt_now,
            text=text,
            status=ProcessStatus.PENDING,
        )

        with Session(self.engine, expire_on_commit=False) as session:
            session.add(note)
            session.commit()
        return note

    def edit_note(self, id: int, user_id:str, update_dict:Dict) -> Optional[Note]:
        editable_columns = ["text","tags","extracted_date"]
        update_dict = {k:v for k,v in update_dict.items() if k in editable_columns}
        if not update_dict:
            return None
        
        query = select(Note).where(Note.id == id, Note.user_id == user_id)
        dt_now = datetime.now(tz=timezone.utc)
        note = None
        with Session(self.engine, expire_on_commit=False) as session:
            note = session.scalars(query).first() 
            if note is not None:
                for k,v in update_dict.items():                    
                    note.__setattr__(k,v)            
                note.updated_at = dt_now
                session.commit()
        return note
    
    def start_note_tagging(self, id: int,user_id:str) -> Optional[Note]:
        query = select(Note).where(Note.id == id, Note.user_id == user_id)
        dt_now = datetime.now(tz=timezone.utc)
        note = None
        with Session(self.engine, expire_on_commit=False) as session:
            note = session.scalars(query).first() 
            if note is not None:
                note.status = ProcessStatus.IN_PROGRESS
                note.updated_at = dt_now
                session.commit()
        return note

    def complete_note_tagging(
        self, id: int,user_id:str,tags: str, extracted_date: Optional[datetime] = None
    ) -> Optional[Note]:
        query = select(Note).where(Note.id == id, Note.user_id == user_id)
        dt_now = datetime.now(tz=timezone.utc)        
        with Session(self.engine, expire_on_commit=False) as session:
            note = session.scalars(query).first() 
            if note is not None:
                note.status = ProcessStatus.COMPLETED
                note.updated_at = dt_now
                note.tags = tags
                note.extracted_date = extracted_date
                session.commit()                
        return note
