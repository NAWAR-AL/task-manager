import 'package:dio/dio.dart';
import 'package:task_manager/core/features/auth/domain/entities/user.dart';
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

  Future<void> deleteUSer(int userId) async {
    try {
      final response = await apiClient.dio.post(
        '/users/$userId',
        data: {'_method': 'DELETE'},
        options: Options(headers: {'Accept': 'application/json'}),
      );
      print('result form api $response');
    } on DioException catch (e) {
      print('RESPONSE DATA: ${e.response?.data}');

      rethrow;
    }
  }

  Future<User> updateUserProfile({
    required int userId,
    required String name,
    required String email,
    String? password,
    String? passwordConfirmation,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'name': name,
        'email': email,
        '_method': 'PATCH',
      };

      if (password != null && password.trim().isNotEmpty) {
        data['password'] = password.trim();
        data['password_confirmation'] = passwordConfirmation?.trim() ?? '';
      }
      print('update user data: $data');
      final response = await apiClient.dio.post(
        '/users/$userId/profile',
        data: data,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      final Map<String, dynamic> userData = response.data['data'];
      print('update done: ${response.data}');
      return UserModel.fromJson(userData);
    } on DioException catch (e) {
      print('error update from remote: ${e.response?.data ?? e.message}');
      rethrow;
    }
  }
}
