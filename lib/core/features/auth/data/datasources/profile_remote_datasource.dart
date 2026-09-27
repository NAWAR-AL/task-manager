import 'package:task_manager/core/network/api_client.dart';
import '../models/user_model.dart';

class ProfileRemoteDatasource {
  final ApiClient apiClient;

  ProfileRemoteDatasource(this.apiClient);

  Future<UserModel> getProfile() async {
    final response = await apiClient.dio.get(
      "https://taskback.orbit-eng.net/api/users",
    );

    // print(response.data);
    return UserModel.fromJson(response.data["data"]);
  }

  Future<List<UserModel>> getUsers() async {
    final response = await apiClient.dio.get(
      "https://taskback.orbit-eng.net/api/users",
    );
    final List<dynamic> responseUsers = response.data['data'];
    // print(response.data);
    return responseUsers.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<List<UserModel>> getDashboardUsers() async {
    final response = await apiClient.dio.get(
      "https://taskback.orbit-eng.net/api/dashboard/users",
    );
    final List<dynamic> responseUsers = response.data['data'];

    return responseUsers.map((json) => UserModel.fromJson(json)).toList();
  }
}
