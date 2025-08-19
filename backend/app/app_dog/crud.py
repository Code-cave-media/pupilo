from sqlalchemy.orm import Session
from app_dog.models import Dog


def get_dog_by_id(db:Session,id):
    return db.query(Dog).filter(id == id).first()

def get_dog_by_user_id(db:Session,user_id):
    return db.query(Dog).filter(user_id == user_id).first()

def create_dog(db:Session,data):
    db_dog = Dog(*data)
    db.add(db_dog)
    db.commit()
    db.refresh(db_dog)
    return db_dog

def update_dog(db:Session,db_dog,update_data:dict):
    for key,value in update_data.items():
        setattr(db_dog,key,value)
    db.commit()
    db.refresh(db_dog)
    return db_dog

