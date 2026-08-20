import 'package:task_manager/core/features/auth/domain/entities/login.dart';

abstract class LoginRepository {
  Future<String> login(Login login);
}
