import '../entities/login.dart';
import '../repositories/login_repository.dart';

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
