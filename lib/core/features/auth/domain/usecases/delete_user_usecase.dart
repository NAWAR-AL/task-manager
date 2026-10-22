import 'package:task_manager/core/features/auth/domain/repositories/profile_repository.dart';

class DeleteUserUsecase {
  final ProfileRepository repository;
  DeleteUserUsecase(this.repository);
  Future<void> call(int id) {
    return repository.deleteUSer(id);
  }
}
