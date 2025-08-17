from fastapi import Depends,HTTPException,APIRouter,Path
from core.deps import get_current_user,get_db
from app_dog.schemas import *
from sqlalchemy.orm import Session
import app_dog.crud as crud_dog
from uuid import UUID
app = APIRouter()

@app.post('',response_model=DogResponse)
def create_dog(data:DogCreate,db:Session = Depends(get_db)):
  db_dog = crud_dog.get_dog_by_user_id(db,data.user_id)
  if db_dog:
    raise HTTPException(detail="User already have dog",status_code=409)
  db_dog = crud_dog.create_dog(db,data.dict())
  return db_dog

@app.put('/{dog_id}',response_model=DogResponse)
def create_dog(data:DogUpdate,db:Session = Depends(get_db),dog_id: UUID = Path(...)):
  db_dog = crud_dog.get_dog_by_id(db,dog_id)
  if not db_dog:
    raise HTTPException(detail="Dog not found",status_code=404)
  db_dog = crud_dog.update_dog(db,db_dog,data.dict())
  return db_dog