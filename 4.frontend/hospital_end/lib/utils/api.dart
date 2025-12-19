import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const String baseUrl = 'http://localhost:3435';

  // 通用请求
  static Future<Map<String, dynamic>> _post(
      String path, Map<String, dynamic> data,
      {String? token}) async {
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> _get(String path, {String? token}) async {
    final response = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    return jsonDecode(response.body);
  }

  // =====================================
  // 1. 登录
  // =====================================
  static Future<Map<String, dynamic>> login(
      String phone, String password) async {
    return _post('/hospital/login', {'phone': phone, 'password': password});
  }

  // =====================================
  // 2. 注册
  // =====================================
  static Future<Map<String, dynamic>> register(
      String phone, String name, String password) async {
    return _post('/hospital/register', {
      'phone': phone,
      'name': name,
      'password': password,
    });
  }

  // =====================================
  // 3. 医生列表
  // =====================================
  static Future<Map<String, dynamic>> doctorList() async {
    return _get('/hospital/doctor_list');
  }

  // =====================================
  // 4. 添加医生
  // =====================================
  static Future<Map<String, dynamic>> addDoctor(String token, String name,
      String phone, String department, String password) async {
    return _post(
        '/hospital/add_doctor',
        {
          'name': name,
          'phone': phone,
          'department': department,
          'password': password,
        },
        token: token);
  }

  // =====================================
  // 5. 删除医生
  // =====================================
  static Future<Map<String, dynamic>> deleteDoctor(String token, int id) async {
    return _post('/hospital/delete_doctor', {'id': id}, token: token);
  }

  // =====================================
  // 6. 药品列表
  // =====================================
  static Future<Map<String, dynamic>> drugList() async {
    return _get('/hospital/drug_list');
  }

  // =====================================
  // 7. 添加药品
  // =====================================
  static Future<Map<String, dynamic>> addDrug(
      String token, String name, int amount) async {
    return _post('/hospital/add_drug', {'name': name, 'amount': amount},
        token: token);
  }

  // =====================================
  // 8. 删除药品
  // =====================================
  static Future<Map<String, dynamic>> deleteDrug(String token, int id) async {
    return _post('/hospital/delete_drug', {'id': id}, token: token);
  }

  // =====================================
  // 9. 就诊记录列表（医生/患者） token in header
  // =====================================
  static Future<Map<String, dynamic>> recordsList(String token) async {
    return _get('/hospital/records_list', token: token);
  }

  // =====================================
  // 10. 获取单条就诊记录
  // =====================================
  static Future<Map<String, dynamic>> getRecord(
      int recordId, String token) async {
    return _get('/hospital/record/$recordId', token: token);
  }

  // =====================================
  // 11. 提交诊断
  // =====================================
  static Future<Map<String, dynamic>> postRecord(String token, int recordId,
      String diagnosis, List<Map<String, dynamic>> drugs) async {
    return _post(
        '/hospital/record',
        {
          'record_id': recordId,
          'diagnosis': diagnosis,
          'drug': drugs,
        },
        token: token);
  }

  // =====================================
  // 12. 历史就诊记录 token in header
  // =====================================
  static Future<Map<String, dynamic>> recordsHistory(String token) async {
    return _get('/hospital/records_history', token: token);
  }

  // =====================================
  // 13. 添加就诊记录
  // =====================================
  /// 新增就诊记录
  static Future<Map<String, dynamic>> addRecord(
    String token, {
    required int departmentId,
    required int doctorId,
    required String complaint,
    required String date,
  }) async {
    return _post(
      '/hospital/add_record',
      {
        'department_id': departmentId,
        'doctor_id': doctorId,
        'complaint': complaint,
        'date': date,
      },
      token: token,
    );
  }

  // =====================================
  // 14. 当前就诊信息 token in header
  // =====================================
  static Future<Map<String, dynamic>> current(String token) async {
    return _get('/hospital/current', token: token);
  }

  /// 获取所有科室
  static Future<List<Map<String, dynamic>>> departments() async {
    final res = await _get('/hospital/departments');
    return List<Map<String, dynamic>>.from(res['data'] ?? []);
  }

  /// 根据科室 ID 获取医生列表
  static Future<List<Map<String, dynamic>>> doctorsByDepartment(
    int departmentId,
  ) async {
    final res = await _get('/hospital/doctors/$departmentId');
    return List<Map<String, dynamic>>.from(res['data'] ?? []);
  }
}
