import '../entities/logout.dart';
import '../repositories/logout_repository.dart';

class LogoutUseCase {
  final LogoutRepository repository;

  LogoutUseCase(this.repository);

  Future<Logout> call() async {
    return await repository.logout();
  }
}