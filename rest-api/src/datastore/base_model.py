from sqlalchemy.orm import DeclarativeBase


class BaseTable(DeclarativeBase):
    pass

    def to_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}
