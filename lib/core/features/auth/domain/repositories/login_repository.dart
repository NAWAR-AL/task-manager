import 'package:task_manager/core/features/auth/domain/entities/login.dart';

abstract class LoginRepository {
  Future<String> login(Login login);
  Future<String> getMyRole();

  /// تجربة كلمة مرور على السيرفر (true = مقبولة) من غير تغيير الجلسة
  Future<bool> verifyPassword(String email, String password);
}
