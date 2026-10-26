import 'package:task_manager/core/features/auth/domain/entities/user.dart';
import 'package:task_manager/core/features/auth/domain/repositories/profile_repository.dart';

class UpdateUserUsercase {
  final ProfileRepository repository;
  UpdateUserUsercase(this.repository);
  Future<void> call(
    User userEntity,
    String? password,
    String? passwordConfirmation,
  ) async {
    return repository.updateUSer(userEntity, password, passwordConfirmation);
  }
}
