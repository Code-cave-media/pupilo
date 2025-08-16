from fastapi import FastAPI
from app.core.database import Base, engine

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Pupilo FastAPI Backend")

# app.include_router()