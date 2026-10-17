import '../repositories/profile_repository.dart';

class UpdateUserRoleUsecase {
  final ProfileRepository repository;

  UpdateUserRoleUsecase(this.repository);

  Future<void> call(int userId, String role) async {
    await repository.updateUserRole(userId, role);
  }
}