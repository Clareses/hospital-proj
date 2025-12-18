from extensions import db


class User(db.Model):
    __tablename__ = "users"

    id = db.Column(db.Integer, primary_key=True)
    phone = db.Column(db.String(20), unique=True, nullable=False)
    name = db.Column(db.String(64), nullable=False)
    password = db.Column(db.String(64), nullable=False)
    role = db.Column(db.String(20), nullable=False)

    def __init__(self, phone, name, password, role):
        self.phone = phone
        self.name = name
        self.password = password
        self.role = role

    def __repr__(self):
        return f"User {self.id} {self.name} {self.phone} {self.role}"
