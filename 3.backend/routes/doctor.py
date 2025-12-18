from flask import Blueprint, request, jsonify
from extensions import db
from models.user import User
from models.doctors import Doctors
from models.department import Department
from utils.decorators import login_required

bp = Blueprint("doctor", __name__, url_prefix="/hospital")


@bp.route("/doctor_list", methods=["GET"])
def doctor_list():
    doctors = Doctors.query.all()
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
    doctor = Doctors(user_id=user.id, department_id=dept.id, phone=data["phone"])
    db.session.add(doctor)
    db.session.commit()

    return jsonify({"status": True, "id": doctor.id})


@bp.route("/delete_doctor", methods=["POST"])
@login_required
def delete_doctor():
    data = request.json
    doctor = Doctors.query.get(data["id"])
    user = User.query.get(doctor.user_id)
    db.session.delete(doctor)
    db.session.delete(user)
    db.session.commit()
    return jsonify({"status": True})


@bp.route("/departments", methods=["GET"])
def departments():
    depts = Department.query.all()
    return jsonify(
        {
            "data": [
                {
                    "id": d.id,
                    "name": d.name,
                }
                for d in depts
            ]
        }
    )


@bp.route("/doctors/<int:department_id>", methods=["GET"])
def doctors_by_department_id(department_id):
    doctors = Doctors.query.filter_by(department_id=department_id).all()

    return jsonify(
        {
            "data": [
                {
                    "id": d.id,  # 医生表的主键
                    "name": d.user.name,  # 通过关系获取 User 表的姓名
                }
                for d in doctors
            ]
        }
    )
