import '../entities/register.dart';
import '../repositories/register_repository.dart';


class RegisterUsecase {
  final RegisterRepository repo;

  RegisterUsecase(this.repo);

  Future<void> call(Register register) async {
    await repo.register(register);
  }
}
