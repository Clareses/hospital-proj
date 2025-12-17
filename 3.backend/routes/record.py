from flask import Blueprint, request, jsonify
from extensions import db
from models.record import Record
from models.record_drug import RecordDrug
from models.drug import Drug
from models.user import User
from models.department import Department
from utils.decorators import login_required

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
    records = Record.query.filter(Record.progress != "done").all()
    result = []
    for r in records:
        user = User.query.get(r.patient_id)
        result.append({"id": r.id, "name": user.name, "record_id": r.id})
    return jsonify({"status": True, "data": result})


@bp.route("/record", methods=["GET"])
@login_required
def get_record():
    record = Record.query.get(request.args.get("record_id"))
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
