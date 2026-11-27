import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/core/network/api_client.dart';
import 'package:task_manager/features/auth/data/models/login_model.dart';
import 'package:task_manager/features/auth/data/models/register_model.dart';
import 'package:task_manager/features/auth/data/models/user_model.dart';
import 'package:task_manager/features/auth/domain/entities/user.dart';

import '../models/reset_password_model.dart';

String baseUrl = 'https://taskback.orbit-eng.net/api';

class ForgotPasswordRemoteDataSource {
  final ApiClient apiClient;

  ForgotPasswordRemoteDataSource(this.apiClient);

  Future<void> forgotPassword(String email) async {
    await apiClient.dio.post("/forgot-password", data: {"email": email});
    // print('email user is $email');
  }

  Future<void> resetPassword(ResetPasswordModel model) async {
    await apiClient.dio.post("/reset-password", data: model.toJson());
  }
}

class ProfileRemoteDatasource {
  final ApiClient apiClient;

  ProfileRemoteDatasource(this.apiClient);
  Future<UserModel> getProfile() async {
    final response = await apiClient.dio.post(" /me");

    return UserModel.fromJson(response.data["data"]);
  }

  Future<UserModel> getUser(int id) async {
    final response = await apiClient.dio.get("/users/$id");

    return UserModel.fromJson(response.data["data"]);
  }

  Future<void> createUser(RegisterModel register) async {
    await apiClient.dio.post("/register", data: register.toJson());
  }

  Future<List<UserModel>> getUsers() async {
    final response = await apiClient.dio.get("/users");
    final List<dynamic> responseUsers = response.data['data'];
    // print(response.data);
    return responseUsers.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<List<UserModel>> getDashboardUsers() async {
    final response = await apiClient.dio.get("/dashboard/users");
    final List<dynamic> responseUsers = response.data['data'];

    return responseUsers.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<void> updateUserRole(int userId, String role) async {
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
      //  final response =
      await apiClient.dio.post(
        '/users/$userId',
        data: {'_method': 'DELETE'},
        options: Options(headers: {'Accept': 'application/json'}),
      );
      // print('result form api $response');
    } on DioException catch (e) {
      //print('RESPONSE DATA: ${e.response?.data}');

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
      //  print('update user data: $data');
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
      //   print('update done: ${response.data}');
      return UserModel.fromJson(userData);
    } on DioException catch (e) {
      //    print('error update from remote: ${e.response?.data ?? e.message}');
      rethrow;
    }
  }
}

class LoginRemoteDatasource {
  final ApiClient apiClient;

  LoginRemoteDatasource(this.apiClient);

  Future<String> login(LoginModel login) async {
    // print(login.toJson());
    final response = await apiClient.dio.post("/login", data: login.toJson());
    // print('Status Code is ya Nour :${response.statusCode}');
    // print(response.data);
    final token = response.data['token'];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    // print('saved tonen $token');
    return token;
  }

  Future<String> getMyRole() async {
    try {
      final response = await apiClient.dio.post(
        '/me',
        options: Options(headers: {'Accept': 'application/json'}),
      );

      final data = response.data['data'];
      final id = data['id'];
      final role = data['role'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', id);
      await prefs.setString('user_role', role);
      // بنبخزن الإيميل حتى تشتغل صفحة تغيير كلمة المرور
      // حتى مع الجلسات القديمة (اللي سجّلت دخول قبل ما ينضاف هالحفظ)
      final email = data['email'];
      if (email is String && email.isNotEmpty) {
        await prefs.setString('user_email', email);
      }

      return role;
    } on DioException catch (e) {
      // print('ME ERROR STATUS: ${e.response?.statusCode}');

      //  print('ME ERROR DATA: ${e.response?.data}');
      rethrow;
    }
  }

  Future<bool> verifyPassword(String email, String password) async {
    try {
      await apiClient.dio.post(
        "/login",
        data: LoginModel(email: email, password: password).toJson(),
      );
      return true;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      // 401/400/422 = كلمة المرور غلط — غير هيك (شبكة/سيرفر) بتطلع لفوق
      if (status == 401 || status == 400 || status == 422) {
        return false;
      }
      rethrow;
    }
  }
}

class LogoutRemoteDataSource {
  final Dio dio;

  LogoutRemoteDataSource(this.dio);

  Future<bool> logout() async {
    try {
      final response = await dio.post('/logout');

      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return true;
      }

      rethrow;
    }
  }
}

class RegisterRemoteDatasource {
  final ApiClient apiClient;

  RegisterRemoteDatasource(this.apiClient);

  Future<void> register(RegisterModel register) async {
    await apiClient.dio.post("/register", data: register.toJson());
    // print('response for register${response.statusCode}');
  }
}
