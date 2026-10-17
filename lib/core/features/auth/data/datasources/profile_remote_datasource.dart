import 'package:dio/dio.dart';
import 'package:task_manager/core/network/api_client.dart';
import '../models/register_model.dart';
import '../models/user_model.dart';

class ProfileRemoteDatasource {
  final ApiClient apiClient;

  ProfileRemoteDatasource(this.apiClient);
  Future<UserModel> getProfile() async {
    final response = await apiClient.dio.post(
      "https://taskback.orbit-eng.net/api/me",
    );

    return UserModel.fromJson(response.data["data"]);
  }

  Future<UserModel> getUser(int id) async {
    final response = await apiClient.dio.get(
      "https://taskback.orbit-eng.net/api/users/$id",
    );

    return UserModel.fromJson(response.data["data"]);
  }

  Future<void> createUser(RegisterModel register) async {
    await apiClient.dio.post(
      "https://taskback.orbit-eng.net/api/register",
      data: register.toJson(),
    );
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

  Future<void> updateUserRole(int userId, String role) async {
    // السيرفر التشغيلي يعمل على IIS/Plesk الذي يحجب فعل PUT،
    // لذلك نرسل POST مع هيدر X-HTTP-Method-Override ليقرأه لاراڤيل كـ PUT.
    // كما يجب إرسال الـ body بصيغة form-encoded (application/x-www-form-urlencoded)
    // لأن جسم PUT بصيغة JSON يفد فارغاً عبر IIS.
    await apiClient.dio.post(
      "/users/$userId/role",
      data: {"role": role},
      options: Options(
        headers: {
          'Accept': 'application/json',
          'X-HTTP-Method-Override': 'PUT',
        },
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
  }
}
