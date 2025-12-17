from extensions import db


class Record(db.Model):
    __tablename__ = "records"

    id = db.Column(db.Integer, primary_key=True)
    patient_id = db.Column(db.Integer, db.ForeignKey("users.id"))
    doctor_id = db.Column(db.Integer, db.ForeignKey("doctors.id"))
    department_id = db.Column(db.Integer, db.ForeignKey("departments.id"))
    complaint = db.Column(db.Text)
    diagnosis = db.Column(db.Text)
    progress = db.Column(db.String(20))
    visit_date = db.Column(db.String(20))
