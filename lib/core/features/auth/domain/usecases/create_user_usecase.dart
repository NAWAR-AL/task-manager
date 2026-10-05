import 'package:task_manager/core/features/auth/domain/entities/register.dart';
import 'package:task_manager/core/features/auth/domain/repositories/profile_repository.dart';

class CreateUserUsecase {
  final ProfileRepository repo;
  CreateUserUsecase(this.repo);
  Future<void> call(Register register) async {
    return await repo.createUser(register);
  }
}