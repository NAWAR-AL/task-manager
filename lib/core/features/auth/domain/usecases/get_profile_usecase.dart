import '../entities/user.dart';
import '../repositories/profile_repository.dart';

class GetProfileUsecase {
  final ProfileRepository repo;

  GetProfileUsecase(this.repo);

  Future<User> call() async {
    return await repo.getProfile();
  }
}
