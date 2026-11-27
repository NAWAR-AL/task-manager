import 'package:task_manager/features/auth/domain/entities/user.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';

class GetSingleUserUsecase {
  final ProfileRepository repo;
  GetSingleUserUsecase(this.repo);
  Future<User> call(int id) async {
    return await repo.getUser(id);
  }
}
