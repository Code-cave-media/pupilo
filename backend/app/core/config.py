from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    PROJECT_NAME: str = "FastAPI App"
    DATABASE_URL: str
    ACCESS_TOKEN_EXPIRE_DAYS = 30
    SECRET_KEY:str
    ALGORITHM: str = "HS256"
    GOOGLE_CLIENT_ID:str
    RESEND_FROM_ADDRESS:str
    RESEND_API_KEY : str
    STRIPE_SECRET_KEY: str
    STRIPE_PRICE_ID:str
    STRIPE_WEBHOOK_SECRET : str
    class Config:
        env_file = ".env"

settings = Settings()
