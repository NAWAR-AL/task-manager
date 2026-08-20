import 'package:dio/dio.dart';

class LogoutRemoteDataSource {
  final Dio dio;

  LogoutRemoteDataSource(this.dio);

  Future<bool> logout() async {
    final response = await dio.delete(
      'https://dummyjson.com/users/1',
    );

    return response.statusCode == 200;
  }
}