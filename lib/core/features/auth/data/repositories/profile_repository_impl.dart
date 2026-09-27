import '../../domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource remote;

  ProfileRepositoryImpl(this.remote);

  @override
  Future<User> getProfile() async {
    return await remote.getProfile();
  }

  @override
  Future<List<User>> getUsers() async {
    return await remote.getUsers();
  }

  @override
  Future<List<User>> getDashboardUsers() async {
    return await remote.getDashboardUsers();
  }
}
