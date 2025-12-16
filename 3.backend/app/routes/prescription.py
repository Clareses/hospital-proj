from flask import Blueprint, request, jsonify
from ..db import get_db


bp = Blueprint("prescription", __name__)


@bp.post("/create")
def create_prescription():
    data = request.json
    db = get_db()

    cur = db.execute(
        "INSERT INTO Prescription (emr_id, status, created_at) VALUES (?, 'pending', datetime('now'))",
        (data["emr_id"],),
    )
    pres_id = cur.lastrowid

    # 插入处方明细
    for item in data["items"]:
        db.execute(
            "INSERT INTO PrescriptionItem (prescription_id, drug_id, quantity, days) VALUES (?, ?, ?, ?)",
            (pres_id, item["drug_id"], item["quantity"], item["days"]),
        )

    db.commit()
    return jsonify({"id": pres_id}), 201


@bp.get("/<int:id>")
def get_prescription(id):
    db = get_db()
    pres = db.execute("SELECT * FROM Prescription WHERE id=?", (id,)).fetchone()
    if not pres:
        return jsonify({"error": "not found"}), 404

    items = db.execute(
        "SELECT * FROM PrescriptionItem WHERE prescription_id=?", (id,)
    ).fetchall()

    return jsonify({"prescription": dict(pres), "items": [dict(i) for i in items]})


@bp.post("/<int:id>/dispense")
def dispense(id):
    db = get_db()
    db.execute("UPDATE Prescription SET status='dispensed' WHERE id=?", (id,))
    db.commit()
    return jsonify({"success": True})
