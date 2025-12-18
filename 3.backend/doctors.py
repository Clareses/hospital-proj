from extensions import db


class Doctors(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), unique=True)
    department_id = db.Column(db.Integer, db.ForeignKey("departments.id"))
    phone = db.Column(db.String(20))
    created_at = db.Column(db.DateTime)

    user = db.relationship("User")
