import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';

import '../entities/login.dart';


class LoginUsecase {
  final LoginRepository repo;

  LoginUsecase(this.repo);

  Future<String> call(Login login) async {
    return await repo.login(login);
  }

  Future<String> getMyRole() async {
    return await repo.getMyRole();
  }

  Future<bool> verifyPassword(String email, String password) async {
    return await repo.verifyPassword(email, password);
  }
}
