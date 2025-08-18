from uuid import UUID
from datetime import datetime
from sqlalchemy.dialects.postgresql import UUID as PG_UUID, BIGINT
from sqlalchemy.ext.declarative import declarative_base
from core.database import Base
from sqlalchemy import (
  Column, String, DateTime, Date, Enum, ForeignKey,Boolean
)
from common.mixin import CreatedUpdatedAtMixin,IDMixin
from sqlalchemy.orm import relationship



class Subscription(Base,CreatedUpdatedAtMixin,IDMixin):
  __tablename__ = "subscriptions"

  user_id = Column(PG_UUID(as_uuid=True), ForeignKey("users.id"), nullable=False,unique=True)
  stripe_customer_id = Column(String(50), nullable=False)
  status = Column(String, nullable=False)
  stripe_subscription_id = Column(String, nullable=True)
  price_id = Column(String(50), nullable=True)
  current_period_end = Column(DateTime, nullable=True)  
  cancel_at_period_end = Column(Boolean, default=True)
  trial_used = Column(Boolean, default=False)


  user = relationship(
      "User",
      back_populates="subscription"
    )
  def __repr__(self):
    return f"<Subscription(id={self.id}, user_id={self.user_id}, status={self.status})>"