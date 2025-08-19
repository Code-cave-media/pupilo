from pydantic import BaseModel
from app_subscription.schemas import SubscriptionResponse
from app_dog.schemas import DogResponse
class GoogleLoginRequest(BaseModel):
  token : str

class LoginRequest(BaseModel):
  email : str
  password : str

class UserResponse(BaseModel):
  email : str
  assistant_personality : str
  subscription : SubscriptionResponse | None 
  id : str
  dog : DogResponse | None

class LoginResponse(BaseModel):
  token : str
  user : UserResponse

class ForgotPassword(BaseModel):
  email: str | None = None
  ref: str | None = None

  def __init__(self, **data):
    super().__init__(**data)
    if not (self.email or self.ref):
      raise ValueError("Either 'email' or 'ref' must be provided.")

class ForgotPasswordResponse(BaseModel):
  email :set
  ref : str

class ForgotPasswordOTPVerify(BaseModel):
  ref : str
  otp :str

class ForgotPasswordPasswordReset(BaseModel):
  ref : str
  password :str
