import 'package:task_manager/features/auth/domain/entities/user.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';

class GetDashboardUsersUsecase {
  final ProfileRepository repo;
  GetDashboardUsersUsecase(this.repo);
  Future<List<User>> call() async {
    return await repo.getDashboardUsers();
  }
}
