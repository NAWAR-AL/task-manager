import 'package:task_manager/core/features/auth/domain/entities/user.dart';
import 'package:task_manager/core/features/auth/domain/repositories/profile_repository.dart';

class GetDashboardUsersUsecase {
  final ProfileRepository repo;
  GetDashboardUsersUsecase(this.repo);
  Future<List<User>> call() async {
    return await repo.getUsers();
  }
}
