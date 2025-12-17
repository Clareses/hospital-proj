from extensions import db


class RecordDrug(db.Model):
    __tablename__ = "record_drugs"

    id = db.Column(db.Integer, primary_key=True)
    record_id = db.Column(db.Integer, db.ForeignKey("records.id"))
    drug_id = db.Column(db.Integer, db.ForeignKey("drugs.id"))
    amount = db.Column(db.Integer)
