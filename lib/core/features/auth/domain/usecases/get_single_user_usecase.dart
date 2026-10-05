import 'package:task_manager/core/features/auth/domain/entities/user.dart';
import 'package:task_manager/core/features/auth/domain/repositories/profile_repository.dart';

class GetSingleUserUsecase {
  final ProfileRepository repo;
  GetSingleUserUsecase(this.repo);
  Future<User> call(int id) async {
    return await repo.getUser(id);
  }
}