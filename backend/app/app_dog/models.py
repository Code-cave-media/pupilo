from sqlalchemy import Column, Integer, String,UUID,SmallInteger,JSON
from app.core.database import Base
from common.mixin import CreatedUpdatedAtMixin,IDMixin
import uuid
from sqlalchemy.dialects.postgresql import UUID, JSONB, TIMESTAMP
from sqlalchemy import Column, String, SmallInteger, ForeignKey


class Dog(Base, CreatedUpdatedAtMixin, IDMixin):
    __tablename__ = "dogs"

    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    name = Column(String(100), nullable=False)
    age = Column(SmallInteger)
    breed = Column(String(100))
    health_issues = Column(JSONB, default=list)

