from app_subscription.models import Subscription
from sqlalchemy.orm import Session


def get_subscription_by_user_id(db: Session, user_id):
    return db.query(Subscription).filter(Subscription.user_id == user_id).first()


def get_subscription_by_customer_id(db: Session, customer_id):
    return db.query(Subscription).filter(Subscription.stripe_customer_id == customer_id).first()

def get_subscription_by_subscription_id(db: Session, subscription_id):
    return db.query(Subscription).filter(Subscription.stripe_subscription_id == subscription_id).first()

def create_subscription(db:Session,data):
  db_sub = Subscription(**data)
  # for key,value in data.items():
  #   setattr(db_sub,key,value)
  db.add(db_sub)
  db.commit()
  db.refresh(db_sub)
  return db_sub

def update_subscription(db:Session,db_sub:Subscription,data):
  for key,value in data.items():
    setattr(db_sub,key,value)
  db.commit()
  db.refresh(db_sub)
  return db_sub