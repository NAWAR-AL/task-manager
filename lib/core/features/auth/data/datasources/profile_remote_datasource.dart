import 'package:task_manager/core/network/api_client.dart';
import '../models/user_model.dart';

class ProfileRemoteDatasource {
  final ApiClient apiClient;

  ProfileRemoteDatasource(this.apiClient);

  Future<UserModel> getProfile() async {
    final response = await apiClient.dio.get("https://taskback.orbit-eng.net/api/users");

     return UserModel.fromJson(response.data["data"]);
  }
}
