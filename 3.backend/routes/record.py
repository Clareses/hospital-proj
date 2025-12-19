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
    dept_id = data["department_id"]
    doc_id = data["doctor_id"]

    record = Record(
        patient_id=request.user["uid"],
        doctor_id=doc_id,
        department_id=dept_id,
        complaint=data["complaint"],
        visit_date=data["date"],
        progress="pending",
        diagnosis="",
    )

    db.session.add(record)
    db.session.commit()
    return jsonify({"status": True})


@bp.route("/records_list", methods=["GET"])
@login_required
def records_list():
    auth = request.headers.get("Authorization")
    if not auth or not auth.startswith("Bearer "):
        return jsonify({"status": False, "msg": "missing token"}), 401

    token = auth[7:]
    payload = verify_token(token)
    if not payload:
        return jsonify({"status": False, "msg": "invalid token"}), 401

    uid = payload["uid"]
    role = payload["role"]

    if role != "doctor":
        return jsonify({"status": False, "msg": "permission denied"}), 403

    # 2. 注意：SQLAlchemy 不能用 Python 的 and
    records = Record.query.filter(
        Record.doctor_id == uid, Record.progress != "done"
    ).all()

    result = []
    for r in records:
        user = User.query.get(r.patient_id)
        result.append({"name": user.name, "record_id": r.id})

    return jsonify({"status": True, "data": result})


@bp.route("/record/<int:record_id>", methods=["GET"])
@login_required
def get_record(record_id):
    record = Record.query.get(record_id)
    if not record:
        return jsonify({"status": False, "msg": "record not found"}), 404

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
    try:
        uid = request.user["uid"]

        record = (
            Record.query.filter(
                Record.patient_id == uid,
                Record.progress != "done",
            )
            .order_by(Record.id.desc())
            .first()
        )

        if not record:
            return jsonify(
                {"status": False, "msg": "no record"}
            ), 200  # 返回 200 而不是 404

        dept = Department.query.get(record.department_id)

        return jsonify(
            {
                "status": True,
                "overview": record.complaint,
                "time": record.visit_date,
                "department": dept.name if dept else None,
                "progress": record.progress,
            }
        )
    except Exception as e:
        print(e)
        return jsonify({"status": False, "msg": str(e)}), 200


@bp.route("/records_history", methods=["GET"])
@login_required
def records_history():
    uid = request.user["uid"]
    role = request.user["role"]

    if role == "patient":
        records = (
            Record.query.filter(Record.patient_id == uid)
            .order_by(Record.id.desc())
            .all()
        )
    else:
        records = (
            Record.query.filter(Record.doctor_id == uid)
            .order_by(Record.id.desc())
            .all()
        )

    result = []

    for r in records:
        # 查医生 → user
        doctor = User.query.get(r.doctor_id)
        doctor_user = User.query.get(doctor.id) if doctor else None

        # 查科室
        dept = Department.query.get(r.department_id)

        # 查药品
        record_drugs = (
            db.session.query(RecordDrug, Drug)
            .join(Drug, RecordDrug.drug_id == Drug.id)
            .filter(RecordDrug.record_id == r.id)
            .all()
        )

        result.append(
            {
                "name": doctor_user.name if doctor_user else None,
                "complaint": r.complaint,
                "time": r.visit_date,
                "diagnosis": r.diagnosis,
                "progress": r.progress,
                "department": dept.name if dept else None,
                "drug": [
                    {
                        "name": drug.name,
                        "amount": rd.amount,
                    }
                    for rd, drug in record_drugs
                ],
            }
        )

    return jsonify({"status": True, "data": result})
