from functools import wraps
from flask import request, jsonify
from utils.jwt import verify_token


def login_required(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        # 优先从 Authorization header 获取
        auth_header = request.headers.get("Authorization", "")
        token = None
        if auth_header.startswith("Bearer "):
            token = auth_header[7:]
        # 如果还没有，可以兼容 query string
        if not token:
            token = request.args.get("token")

        if not token:
            return jsonify({"status": False, "msg": "token required"}), 200

        payload = verify_token(token)
        if not payload:
            return jsonify({"status": False, "msg": "invalid token"}), 200

        request.user = payload
        return f(*args, **kwargs)

    return wrapper
