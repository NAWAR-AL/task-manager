import '../entities/login.dart';
import '../repositories/login_repository.dart';


class LoginUsecase {
  final LoginRepository repo;

  LoginUsecase(this.repo);

  Future<String> call(Login login) async {
    return  await repo.login(login);
  }
}