import '../../domain/entities/register.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/register_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource remote;

  ProfileRepositoryImpl(this.remote);

  @override
  Future<User> getProfile() async {
    return await remote.getProfile();
  }

  @override
  Future<User> getUser(int id) async {
    return await remote.getUser(id);
  }

  @override
  Future<List<User>> getUsers() async {
    return await remote.getUsers();
  }

  @override
  Future<List<User>> getDashboardUsers() async {
    return await remote.getDashboardUsers();
  }

  @override
  Future<void> createUser(Register register) async {
    final model = RegisterModel(
      name: register.name,
      email: register.email,
      password: register.password,
      password_confirmation: register.password_confirmation,
    );
    await remote.createUser(model);
  }

  @override
  Future<void> updateUserRole(int userId, String role) async {
    await remote.updateUserRole(userId, role);
  }
}