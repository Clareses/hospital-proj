from flask import Blueprint, request, jsonify
from ..db import get_db


bp = Blueprint("patient", __name__)


@bp.post("/")
def create_patient():
    data = request.json
    db = get_db()
    cur = db.execute(
        "INSERT INTO Patient (name, phone, id_number) VALUES (?, ?, ?)",
        (data["name"], data["phone"], data["id_number"]),
    )
    db.commit()
    return jsonify({"id": cur.lastrowid}), 201


@bp.get("/<int:id>")
def get_patient(id):
    db = get_db()
    row = db.execute("SELECT * FROM Patient WHERE id=?", (id,)).fetchone()
    if not row:
        return jsonify({"error": "patient not found"}), 404
    return jsonify(dict(row))
