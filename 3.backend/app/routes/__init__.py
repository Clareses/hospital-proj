from .patient import bp as patient_bp
from .visit import bp as visit_bp
from .doctor import bp as doctor_bp
from .prescription import bp as prescription_bp
from .drug import bp as drug_bp


def register_routes(app):
    app.register_blueprint(patient_bp, url_prefix="/patient")
    app.register_blueprint(visit_bp, url_prefix="/visit")
    app.register_blueprint(doctor_bp, url_prefix="/doctor")
    app.register_blueprint(prescription_bp, url_prefix="/prescription")
    app.register_blueprint(drug_bp, url_prefix="/drug")
