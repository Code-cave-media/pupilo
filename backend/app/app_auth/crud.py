from app_auth.models import User,ForgotPassword
from sqlalchemy.orm import Session
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=['bcrypt'],deprecated='auto')


def get_user_by_email(db:Session,email):
    return db.query(User).filter(email == email).first()


def verify_password(plain_password,hashed_password):
    return pwd_context.verify(plain_password,hashed_password)

def create_user(db:Session,email,password=None):
    if password:
        password = pwd_context.hash(password)
    new_user = User(
        email=email,
        password = password
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user

def update_user_password(db:Session,user,password):
    hashed_password = pwd_context.hash(password)
    user.password = hashed_password
    db.commit()
    db.refresh(user)
    return user
def get_forgot_password_by_email(db:Session,email):
    return db.query(ForgotPassword).filter(email==email).first()

def get_forgot_password_by_ref(db:Session,ref):
    return db.query(ForgotPassword).filter(ref==ref).first()


def create_forgot_password(db: Session, email, otp):
    db_forgot = ForgotPassword(
        email=email,
        otp=otp
    )
    db.add(db_forgot)
    db.commit()
    db.refresh(db_forgot)
    return db_forgot

def update_forgot_password(db: Session, db_forgot, update_data: dict):
    for key, value in update_data.items():
        setattr(db_forgot, key, value)
    db.commit()
    db.refresh(db_forgot)
    return db_forgot