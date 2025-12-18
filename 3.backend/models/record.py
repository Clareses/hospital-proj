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

    def __init__(
        self,
        patient_id,
        doctor_id,
        department_id,
        complaint,
        diagnosis,
        progress,
        visit_date,
    ):
        self.patient_id = patient_id
        self.doctor_id = doctor_id
        self.department_id = department_id
        self.complaint = complaint
        self.diagnosis = diagnosis
        self.progress = progress
        self.visit_date = visit_date

    def __repr__(self):
        return f"Record {self.id} {self.patient_id} {self.doctor_id} {self.department_id} {self.complaint} {self.diagnosis} {self.progress} {self.visit_date}"
