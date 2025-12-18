from flask import Blueprint, request, jsonify
from extensions import db
from models.record import Record
from models.record_drug import RecordDrug
from models.drug import Drug
from models.user import User
from models.department import Department
from utils.decorators import login_required
from utils.jwt import verify_token

bp = Blueprint("record", __name__, url_prefix="/hospital")


@bp.route("/add_record", methods=["POST"])
@login_required
def add_record():
    data = request.json
    dept = Department.query.filter_by(name=data["department"]).first()
    record = Record(
        patient_id=request.user["uid"],
        department_id=dept.id,
        complaint=data["complaint"],
        visit_date=data["date"],
        progress="pending",
    )
    db.session.add(record)
    db.session.commit()
    return jsonify({"status": True})


@bp.route("/records_list", methods=["GET"])
@login_required
def records_list():
    data = request.json
    tok = data["token"]
    payload = verify_token(tok)
    if not payload:
        return jsonify({"status": False, "msg": "invalid token"})

    uid = payload["uid"]
    role = payload["role"]

    if role == "doctor":
        records = Record.query.filter(
            Record.doctor_id == uid and Record.progress != "done"
        ).all()
        result = []
        for r in records:
            user = User.query.get(r.patient_id)
            result.append({"name": user.name, "record_id": r.id})
        return jsonify({"status": True, "data": result})
    else:
        return jsonify({"status": False})


@bp.route("/record", methods=["GET"])
@login_required
def get_record():
    id = request.json["record_id"]
    print(id)
    record = Record.query.get(id)
    return jsonify({"status": True, "complaint": record.complaint})


@bp.route("/record", methods=["POST"])
@login_required
def post_record():
    data = request.json
    record = Record.query.get(data["record_id"])
    record.diagnosis = data["diagnosis"]
    record.progress = "done"

    for d in data["drug"]:
        drug = Drug.query.filter_by(name=d["name"]).first()
        rd = RecordDrug(record_id=record.id, drug_id=drug.id, amount=d["amount"])
        drug.amount -= d["amount"]
        db.session.add(rd)

    db.session.commit()
    return jsonify({"status": True})


@bp.route("/current", methods=["GET"])
@login_required
def current():
    record = (
        Record.query.filter_by(patient_id=request.user["uid"])
        .order_by(Record.id.desc())
        .first()
    )
    dept = Department.query.get(record.department_id)
    return jsonify(
        {
            "status": True,
            "overview": record.complaint,
            "time": record.visit_date,
            "department": dept.name,
            "progress": record.progress,
        }
    )


@bp.route("/records_history", methods=["GET"])
@login_required
def records_history():
    data = request.json
    tok = data["token"]
    payload = verify_token(tok)
    if not payload:
        return jsonify({"status": False, "msg": "invalid token"})

    uid = payload["uid"]
    records = Record.query.filter(Record.patient_id == uid).all()
    result = []
    for r in records:
        record_drugs = (
            db.session.query(RecordDrug, Drug)
            .join(Drug, RecordDrug.drug_id == Drug.id)
            .filter(RecordDrug.record_id == r.id)
            .all()
        )
        user = User.query.get(r.doctor_id)
        result.append(
            {
                "name": user.name,
                "complaint": r.complaint,
                "diagnosis": r.diagnosis,
                "progress": r.progress,
                "drug": [
                    {
                        "name": d[1].name,
                        "amount": d[0].amount,
                    }
                    for d in record_drugs
                ],
            }
        )
    return jsonify({"status": True, "data": result})
