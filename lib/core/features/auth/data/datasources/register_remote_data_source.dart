import 'package:task_manager/core/network/api_client.dart';
import '../models/register_model.dart';

class RegisterRemoteDatasource {
  final ApiClient apiClient;

  RegisterRemoteDatasource(this.apiClient);

  Future<void> register(RegisterModel register) async {
    final response = await apiClient.dio.post(
      "https://fakestoreapi.com/users",
      data: register.toJson(),
    );
    // print(response.statusCode);
    
  }
}
