

import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';

class DeleteUserUsecase {
  final ProfileRepository repository;
  DeleteUserUsecase(this.repository);
  Future<void> call(int id) {
    return repository.deleteUSer(id);
  }
}
