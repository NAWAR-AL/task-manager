import 'package:task_manager/features/auth/domain/entities/user.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';

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
