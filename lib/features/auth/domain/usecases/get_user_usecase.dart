import 'package:task_manager/features/auth/domain/entities/user.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';

class GetUsersUsecase {
  final ProfileRepository repo;
  GetUsersUsecase(this.repo);
  Future<List<User>> call() async {
    return await repo.getUsers();
  }
}
