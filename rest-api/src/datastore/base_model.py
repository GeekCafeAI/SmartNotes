from typing import Optional, Sequence

from sqlalchemy.orm import DeclarativeBase


class BaseTable(DeclarativeBase):
    pass

    def to_dict(self, except_attrs: Optional[Sequence[str]] = None):
        return {
            c.name: getattr(self, c.name)
            for c in self.__table__.columns
            if c.name not in except_attrs
        }
