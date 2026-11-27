import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';

import '../entities/logout.dart';


class LogoutUseCase {
  final LogoutRepository repository;

  LogoutUseCase(this.repository);

  Future<Logout> call() async {
    return await repository.logout();
  }
}