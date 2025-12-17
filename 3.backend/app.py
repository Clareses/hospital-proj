from flask import Flask
from config import Config
from extensions import db
from routes import auth, doctor, drug, record


def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    db.init_app(app)

    app.register_blueprint(auth.bp)
    app.register_blueprint(doctor.bp)
    app.register_blueprint(drug.bp)
    app.register_blueprint(record.bp)

    return app


app = create_app()


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3435, debug=True)
