from fastapi import APIRouter,Depends,HTTPException,BackgroundTasks
from app_auth.schemas import *
from core.deps import get_current_user,get_db
from core.security import create_access_token
from sqlalchemy.orm import Session
import app_auth.crud as crud_auth 
from google.oauth2 import id_token
from google.auth.transport import requests
from core.config import settings
from common.utils import generate_otp
from lib.resend import send_otp_email
app = APIRouter()


@app.post('/verify-me',response_model=UserResponse)
def verify_me(user = Depends(get_current_user)):
  return user

@app.post('/login',response_model=LoginResponse)
def login(data:LoginRequest,db:Session=Depends(get_db)):
  user = crud_auth.get_user_by_email(db,data.email)
  if not user or not crud_auth.verify_password(data.password,user.password):
    raise HTTPException(detail="Invalid Email or password",status_code=400)
  token = create_access_token({'sub':data.email})
  return { 'user':user,'token':token }

@app.post('/google-login')
def google_login(data:GoogleLoginRequest,db:Session=Depends(get_db)):
  idinfo = id_token.verify_oauth2_token(
            data.token,
            requests.Request(),
            settings.GOOGLE_CLIENT_ID
        )
  user_email = idinfo["email"]
  user = crud_auth.get_user_by_email(db,user_email)
  if not user:
    user = crud_auth.create_user(db,user_email)
  token = create_access_token(data={'sub':user_email})
  return {'token':token,'user':user} 

@app.post('/forgot-password/request-otp',response_model=ForgotPasswordResponse)
def forgot_password(data:ForgotPassword,background_tasks: BackgroundTasks,db:Session=Depends(get_db)):
  """
  Used to sent new otp and also resend otp
  """
  email = data.email
  db_forgot = None
  # Case when try to make resend otp
  if data.ref:
    db_forgot = crud_auth.get_forgot_password_by_ref(db,data.ref)
    if not db_forgot:
      raise HTTPException(status_code=404,detail="Ref is invalid")
    email = db_forgot.email

  user = crud_auth.get_user_by_email(email)
  if not user:
    raise HTTPException(status_code=404,detail="User not found")
  generate_otp = generate_otp()
  db_forgot = crud_auth.get_forgot_password_by_email(db,user.email) if not db_forgot else db_forgot
  if not db_forgot:
    db_forgot = crud_auth.create_forgot_password(db,user.email,generate_otp)
  else:
    db_forgot = crud_auth.update_forgot_password(db,db_forgot,{'otp':generate_otp})
  background_tasks.add_task(send_otp_email, user.email, generate_otp)
  return db_forgot

@app.post('/forgot-password/verify-otp')
def verify_otp(data:ForgotPasswordOTPVerify,db:Session=Depends(get_db)):
  # check exist the forgot password with this ref
  db_forgot = crud_auth.get_forgot_password_by_ref(db,data.ref)
  if not db_forgot:
    raise HTTPException(detail="Ref is invalid",status_code=404)
  if not db_forgot.otp == data.otp:
    raise HTTPException(status_code=400,detail="OTP is invalid")
  crud_auth.update_forgot_password(db,db_forgot,{'verified':True})
  return {'detail':"OTP Verified"}

@app.post('/forgot-password/reset-password')
def reset_password(data:ForgotPasswordPasswordReset,db:Session=Depends(get_db)):
  db_forgot = crud_auth.get_forgot_password_by_ref(db,data.ref)
  if not db_forgot:
    raise HTTPException(detail="Ref is invalid",status_code=404)
  if not db_forgot.verified:
    raise HTTPException(status_code=403, detail="OTP not verified")
  user = crud_auth.get_user_by_email(db,db_forgot.email)
  # update password
  crud_auth.update_user_password(db,user,data.password)
  return {'detail':"Password updated"} 

