from flask import Blueprint, request, jsonify
from extensions import db
from models.drug import Drug
from utils.decorators import login_required

bp = Blueprint("drug", __name__, url_prefix="/hospital")


@bp.route("/drug_list", methods=["GET"])
def drug_list():
    drugs = Drug.query.all()
    return jsonify([{"id": d.id, "name": d.name, "amount": d.amount} for d in drugs])


@bp.route("/add_drug", methods=["POST"])
@login_required
def add_drug():
    data = request.json
    drug = Drug(name=data["name"], amount=data["amount"])
    db.session.add(drug)
    db.session.commit()
    return jsonify({"status": True})


@bp.route("/delete_drug", methods=["POST"])
@login_required
def delete_drug():
    data = request.json
    drug = Drug.query.get(data["id"])
    db.session.delete(drug)
    db.session.commit()
    return jsonify({"status": True})
