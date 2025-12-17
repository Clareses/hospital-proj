from extensions import db


class Drug(db.Model):
    __tablename__ = "drugs"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(64), unique=True)
    amount = db.Column(db.Integer)
