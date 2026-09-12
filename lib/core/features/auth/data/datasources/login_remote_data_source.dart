import 'package:task_manager/core/network/api_client.dart';
import '../models/login_model.dart';

class LoginRemoteDatasource {
  final ApiClient apiClient;

  LoginRemoteDatasource(this.apiClient);

  Future<String> login(LoginModel login) async {
    print(login.toJson());
    final response = await apiClient.dio.post(
      "/login",
      data: login.toJson(),
    );
    print('Status Code is ya Nour :${response.statusCode}');
    print(response.data);

    return response.data["token"];
  }
}
