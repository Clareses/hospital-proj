from flask import Blueprint, jsonify
from ..db import get_db


bp = Blueprint("drug", __name__)


@bp.get("/")
def list_drugs():
    db = get_db()
    rows = db.execute("SELECT * FROM Drug").fetchall()
    return jsonify([dict(r) for r in rows])
