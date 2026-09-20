import 'package:dio/dio.dart';
import 'package:task_manager/core/network/api_client.dart';
import '../models/register_model.dart';

class RegisterRemoteDatasource {
  final ApiClient apiClient;

  RegisterRemoteDatasource(this.apiClient);

  Future<void> register(RegisterModel register) async {
    try {
      final response = await apiClient.dio.post(
        "https://taskback.orbit-eng.net/api/register",
        data: register.toJson(),
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE: ${response.data}");
    } on DioException catch (e) {
      print("STATUS CODE: ${e.response?.statusCode}");
      print("RESPONSE DATA: ${e.response?.data}");
      print("SENT DATA: ${e.requestOptions.data}");

      rethrow;
    }
  }
}