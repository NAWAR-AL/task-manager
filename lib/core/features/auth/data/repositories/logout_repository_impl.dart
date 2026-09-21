import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/logout.dart';
import '../../domain/repositories/logout_repository.dart';
import '../datasources/logout_remote_datasource.dart';

class LogoutRepositoryImpl implements LogoutRepository {
  final LogoutRemoteDataSource remoteDataSource;

  LogoutRepositoryImpl(this.remoteDataSource);

  @override
  Future<Logout> logout() async {
    try {
      final result = await remoteDataSource.logout();
      
      // مسح التوكن محلياً بعد نجاح الخروج من السيرفر
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');

      return Logout(success: result);
    } catch (e) {
      // في حال حدوث خطأ أو 401، نحذف التوكن محلياً أيضاً لنسمح للمستخدم بالخروج
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');

      return  Logout(success: true);
    }
  }
}