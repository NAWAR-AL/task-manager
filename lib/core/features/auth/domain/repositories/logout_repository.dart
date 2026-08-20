import '../entities/logout.dart';

abstract class LogoutRepository {
  Future<Logout> logout();
}