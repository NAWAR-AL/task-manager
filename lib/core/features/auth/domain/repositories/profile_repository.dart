import '../entities/register.dart';
import '../entities/user.dart';

abstract class ProfileRepository {
  Future<User> getProfile();
  Future<User> getUser(int id);
  Future<List<User>> getDashboardUsers();
  Future<List<User>> getUsers();
  Future<void> createUser(Register register);
  Future<void> updateUserRole(int userId, String role);
}