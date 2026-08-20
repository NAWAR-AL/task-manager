import '../../domain/entities/logout.dart';
import '../../domain/repositories/logout_repository.dart';
import '../datasources/logout_remote_datasource.dart';

class LogoutRepositoryImpl implements LogoutRepository {
  final LogoutRemoteDataSource remoteDataSource;

  LogoutRepositoryImpl(this.remoteDataSource);

  @override
  Future<Logout> logout() async {
    final result = await remoteDataSource.logout();

    return Logout(
      success: result,
    );
  }
}