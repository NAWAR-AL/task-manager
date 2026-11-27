import 'package:task_manager/features/auth/domain/entities/register.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';


class CreateUserUsecase {
  final ProfileRepository repo;
  CreateUserUsecase(this.repo);
  Future<void> call(Register register) async {
    return await repo.createUser(register);
  }
}
