from pydantic import BaseModel, EmailStr
from typing import List

class DogCreate(BaseModel):
  user_id : str
  name : str
  age : int
  breed : str
  health_issues : List[str]


class DogUpdate(BaseModel):
  name : str
  age : int
  breed : str
  health_issues : List[str]

class DogResponse(BaseModel):
  user_id : str
  name : str
  age : int
  breed : str
  health_issues : List[str]

