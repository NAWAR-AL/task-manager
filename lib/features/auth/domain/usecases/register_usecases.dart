import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';

import '../entities/register.dart';



class RegisterUsecase {
  final RegisterRepository repo;

  RegisterUsecase(this.repo);

  Future<void> call(Register register) async {
    await repo.register(register);
  }
}
