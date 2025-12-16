from flask import Blueprint, request, jsonify
from ..db import get_db


bp = Blueprint("emr", __name__)


@bp.post("/")
def create_emr():
    data = request.json
    db = get_db()
    cur = db.execute(
        "INSERT INTO EMR (visit_id, chief_complaint, diagnosis, treatment, created_at) VALUES (?, ?, ?, ?, datetime('now'))",
        (
            data["visit_id"],
            data["chief_complaint"],
            data["diagnosis"],
            data["treatment"],
        ),
    )
    db.commit()
    return jsonify({"id": cur.lastrowid}), 201


@bp.get("/<int:id>")
def get_emr(id):
    db = get_db()
    row = db.execute("SELECT * FROM EMR WHERE id=?", (id,)).fetchone()
    if not row:
        return jsonify({"error": "EMR not found"}), 404
    return jsonify(dict(row))
