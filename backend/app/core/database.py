from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from .config import settings

engine = create_engine(settings.DATABASE_URL, future=True, echo=True)
Session = sessionmaker(bind=engine, autoflush=False, autocommit=False)
Base = declarative_base()

# Dependency for routes
def get_db():
    db = Session()
    try:
        yield db
    finally:
        db.close()
