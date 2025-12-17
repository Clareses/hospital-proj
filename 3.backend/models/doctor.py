from extensions import db


class Doctor(db.Model):
    __tablename__ = "doctors"

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), unique=True)
    department_id = db.Column(db.Integer, db.ForeignKey("departments.id"))
    phone = db.Column(db.String(20))
