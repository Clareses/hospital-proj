import jwt
import time
from config import Config


def generate_token(user_id, role, expire=7200):
    payload = {"uid": user_id, "role": role, "exp": int(time.time()) + expire}
    return jwt.encode(payload, Config.SECRET_KEY, algorithm="HS256")


def verify_token(token):
    try:
        return jwt.decode(token, Config.SECRET_KEY, algorithms=["HS256"])
    except jwt.ExpiredSignatureError:
        return None
