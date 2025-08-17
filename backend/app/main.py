from fastapi import FastAPI
from app.core.database import Base, engine
from app.api.v1 import routes_auth,routes_dog

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Pupilo FastAPI Backend")

app.include_router(
  routes_auth,
  prefix="/api/v1/auth",
  tags=["auth"],
  name="auth"
)

app.include_router(
  routes_dog,
  prefix="/api/v1/dog",
  tags=["dog"],
  name="dog"
)