import 'package:dio/dio.dart';

class LogoutRemoteDataSource {
  final Dio dio;

  LogoutRemoteDataSource(this.dio);

  Future<bool> logout() async {
    try {
      final response = await dio.post(
        'https://taskback.orbit-eng.net/api/logout',
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return true;
      }

      rethrow;
    }
  }
}