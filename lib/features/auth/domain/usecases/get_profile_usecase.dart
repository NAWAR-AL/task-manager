import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';

import '../entities/user.dart';

class GetProfileUsecase {
  final ProfileRepository repo;

  GetProfileUsecase(this.repo);

  Future<User> call() async {
    return await repo.getProfile();
  }
}
