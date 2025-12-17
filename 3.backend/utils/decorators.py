from flask import request, jsonify
from utils.jwt import verify_token


def login_required(f):
    def wrapper(*args, **kwargs):
        token = request.json.get("token") or request.args.get("token")
        if not token:
            return jsonify({"status": False, "msg": "token required"})

        payload = verify_token(token)
        if not payload:
            return jsonify({"status": False, "msg": "invalid token"})

        request.user = payload
        return f(*args, **kwargs)

    wrapper.__name__ = f.__name__
    return wrapper
