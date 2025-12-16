import 'package:shared_preferences/shared_preferences.dart';

class Global {
  static final Global _instance = Global._internal();
  factory Global() => _instance;
  Global._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }


  static const String _keyIsLogin = 'is_login';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';

  bool get isLogin => _prefs.getBool(_keyIsLogin) ?? false;

  set isLogin(bool value) {
    _prefs.setBool(_keyIsLogin, value);
  }

  String? get userId => _prefs.getString(_keyUserId);

  set userId(String? value) {
    if (value == null) {
      _prefs.remove(_keyUserId);
    } else {
      _prefs.setString(_keyUserId, value);
    }
  }

  String? get userName => _prefs.getString(_keyUserName);

  set userName(String? value) {
    if (value == null) {
      _prefs.remove(_keyUserName);
    } else {
      _prefs.setString(_keyUserName, value);
    }
  }


  Future<void> login({
    required String userId,
    required String userName,
    required String token,
  }) async {
    await _prefs.setBool(_keyIsLogin, true);
    await _prefs.setString(_keyUserId, userId);
    await _prefs.setString(_keyUserName, userName);
  }

  Future<void> logout() async {
    await _prefs.clear();
  }
}
