import '../entities/user.dart';

abstract class ProfileRepository {
  Future<User> getProfile();
  Future<List<User>> getDashboardUsers();
  Future<List<User>> getUsers();
}
