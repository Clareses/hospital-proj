class Config:
    SQLALCHEMY_DATABASE_URI = "sqlite:///hospital.db"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = "hospital-secret"
