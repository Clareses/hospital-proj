from flask import Blueprint, request, jsonify
from extensions import db
from models.user import User
from utils.jwt import generate_token, verify_token

bp = Blueprint("auth", __name__, url_prefix="/hospital")


@bp.route("/login", methods=["POST"])
def login():
    data = request.json
    user = User.query.filter_by(phone=data["phone"], password=data["password"]).first()
    if not user:
        return jsonify({"status": False})

    print(user)

    token = generate_token(user.id, user.role)
    return jsonify({"status": True, "token": token})


@bp.route("/register", methods=["POST"])
def register():
    data = request.json
    user = User(
        phone=data["phone"],
        name=data["name"],
        password=data["password"],
        role="patient",
    )
    db.session.add(user)
    db.session.commit()
    return jsonify({"status": True})
