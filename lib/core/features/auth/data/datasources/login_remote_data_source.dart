import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/core/network/api_client.dart';
import '../models/login_model.dart';

class LoginRemoteDatasource {
  final ApiClient apiClient;

  LoginRemoteDatasource(this.apiClient);

  Future<String> login(LoginModel login) async {
    // print(login.toJson());
    final response = await apiClient.dio.post("/login", data: login.toJson());
    // print('Status Code is ya Nour :${response.statusCode}');
    // print(response.data);
    final token = response.data['token'];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    // print('saved tonen $token');
    return token;
  }

  Future<String> getMyRole() async {
    try {
      final response = await apiClient.dio.post(
        '/me',
        options: Options(headers: {'Accept': 'application/json'}),
      );
      // print('me status ${response.statusCode}');
      // print('ME URL: ${response.requestOptions.uri}');
      // print('ME METHOD: ${response.requestOptions.method}');
      // print('me data:${response.data}');
      final data = response.data['data'];
      final id = data['id'];
      final role = data['role'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', id);
      await prefs.setString('user_role', role);
      // بنبخزن الإيميل حتى تشتغل صفحة تغيير كلمة المرور
      // حتى مع الجلسات القديمة (اللي سجّلت دخول قبل ما ينضاف هالحفظ)
      final email = data['email'];
      if (email is String && email.isNotEmpty) {
        await prefs.setString('user_email', email);
      }
      // print('Saved id $id');
      // print('role is $role');
      return role;
    } on DioException catch (e) {
      print('ME ERROR STATUS: ${e.response?.statusCode}');
      // print('ME ERROR URL: ${e.requestOptions.uri}');
      // print('ME ERROR METHOD: ${e.requestOptions.method}');
      print('ME ERROR DATA: ${e.response?.data}');
      rethrow;
    }
  }

  /// بيجرب كلمة مرور على السيرفر من غير ما يمسك التوكن المحفوظ
  /// (بترجع true إذا السيرفر قبلها) — لصفحة تغيير كلمة المرور
  /// وقت ما تلقى نسخة محفوظة لوكل (جلسات قديمة قبل التحديث)
  Future<bool> verifyPassword(String email, String password) async {
    try {
      await apiClient.dio.post(
        "/login",
        data: LoginModel(email: email, password: password).toJson(),
      );
      return true;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      // 401/400/422 = كلمة المرور غلط — غير هيك (شبكة/سيرفر) بتطلع لفوق
      if (status == 401 || status == 400 || status == 422) {
        return false;
      }
      rethrow;
    }
  }
}
