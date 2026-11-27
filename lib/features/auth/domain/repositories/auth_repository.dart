import '../entities/reset_password.dart';
import 'package:task_manager/features/auth/domain/entities/login.dart';
import '../entities/logout.dart';

import '../entities/register.dart';
import '../entities/user.dart';

abstract class RegisterRepository {
  Future<void> register(Register register);
}

abstract class ProfileRepository {
  Future<User> getProfile();
  Future<User> getUser(int id);
  Future<List<User>> getDashboardUsers();
  Future<List<User>> getUsers();
  Future<void> createUser(Register register);
  Future<void> updateUserRole(int userId, String role);
  Future<void> deleteUSer(int userId);
  Future<void> updateUSer(
    User userEntity,
    String? password,
    String? passwordConfirm,
  );
}

abstract class LogoutRepository {
  Future<Logout> logout();
}

abstract class ForgotPasswordRepository {
  Future<void> forgot(String email);

  Future<void> reset(ResetPassword params);
}

abstract class LoginRepository {
  Future<String> login(Login login);
  Future<String> getMyRole();

  /// تجربة كلمة مرور على السيرفر (true = مقبولة) من غير تغيير الجلسة
  Future<bool> verifyPassword(String email, String password);
}
