from flask import Blueprint, request, jsonify
from ..db import get_db


bp = Blueprint("visit", __name__)


@bp.post("/")
def create_visit():
    data = request.json
    db = get_db()
    cur = db.execute(
        """
        INSERT INTO Visit 
            (patient_id, department, number, status, created_at) 
        VALUES 
            (?, ?, ?, 'waiting', datetime('now'))
        """,
        (data["patient_id"], data["department"], data.get("number", 1)),
    )
    db.commit()
    return jsonify({"id": cur.lastrowid}), 201


@bp.get("/<int:id>")
def get_visit(id):
    db = get_db()
    row = db.execute("SELECT * FROM Visit WHERE id=?", (id,)).fetchone()
    if not row:
        return jsonify({"error": "visit not found"}), 404
    return jsonify(dict(row))


@bp.post("/<int:id>/status")
def update_status(id):
    data = request.json
    db = get_db()
    db.execute("UPDATE Visit SET status=? WHERE id=?", (data["status"], id))
    db.commit()
    return jsonify({"success": True})
