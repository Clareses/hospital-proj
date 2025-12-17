from flask import Blueprint, request, jsonify
from extensions import db
from models.user import User
from models.doctor import Doctor
from models.department import Department
from utils.decorators import login_required

bp = Blueprint("doctor", __name__, url_prefix="/hospital")


@bp.route("/doctor_list", methods=["GET"])
def doctor_list():
    doctors = Doctor.query.all()
    result = []
    for d in doctors:
        user = User.query.get(d.user_id)
        dept = Department.query.get(d.department_id)
        result.append(
            {"id": d.id, "name": user.name, "phone": d.phone, "department": dept.name}
        )
    return jsonify(result)


@bp.route("/add_doctor", methods=["POST"])
@login_required
def add_doctor():
    data = request.json
    user = User(
        phone=data["phone"], name=data["name"], password=data["password"], role="doctor"
    )
    db.session.add(user)
    db.session.commit()

    dept = Department.query.filter_by(name=data["department"]).first()
    doctor = Doctor(user_id=user.id, department_id=dept.id, phone=data["phone"])
    db.session.add(doctor)
    db.session.commit()

    return jsonify({"status": True, "id": doctor.id})


@bp.route("/delete_doctor", methods=["POST"])
@login_required
def delete_doctor():
    data = request.json
    doctor = Doctor.query.get(data["id"])
    user = User.query.get(doctor.user_id)
    db.session.delete(doctor)
    db.session.delete(user)
    db.session.commit()
    return jsonify({"status": True})
