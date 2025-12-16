from flask import Blueprint, request, jsonify
from ..db import get_db


bp = Blueprint("doctor", __name__)


@bp.post("/login")
def doctor_login():
    data = request.json
    db = get_db()
    row = db.execute(
        "SELECT * FROM Doctor WHERE name=? AND password=?",
        (data["name"], data["password"]),
    ).fetchone()
    if not row:
        return jsonify({"success": False}), 401
    return jsonify({"success": True, "doctor": dict(row)})
