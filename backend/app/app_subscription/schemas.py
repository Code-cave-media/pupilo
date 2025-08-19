from pydantic import BaseModel
from datetime import datetime


class SubscriptionSessionCreate(BaseModel):
  success_url : str
  cancel_url : str

class SubscriptionResponse(BaseModel):
    id : str
    status: str
    stripe_customer_id: str | None = None
    stripe_subscription_id: str | None = None
    price_id: str | None = None
    current_period_end: datetime | None = None
    cancel_at_period_end: bool | None = None
    trial_used: bool | None = None
    created_at : datetime
    updated_at : datetime
