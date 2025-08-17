from sqlalchemy import Column, Integer, String,UUID,Boolean
from app.core.database import Base
from common.mixin import CreatedUpdatedAtMixin
import uuid
from sqlalchemy.orm import relationship

class User(Base,CreatedUpdatedAtMixin):
  __tablename__ = "users"
  id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4, unique=True, nullable=False)
  email = Column(String,unique=True)
  password  = Column(String,nullable=True)
  assistant_personality = Column(String,default='warm')
  subscription_status = Column(String,nullable=True)

  dog = relationship(
    back_populates="owner",
    uselist=False,
    cascade="all, delete-orphan"
  )


class ForgotPassword(Base):
  __tablename__ = "forgot_password"
  email = Column(String,unique=True,primary_key=True)
  ref = Column(UUID(as_uuid=True), default=uuid.uuid4, unique=True, nullable=False)
  otp = Column(String)
  verified = Column(Boolean,default=False)