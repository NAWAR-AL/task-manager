import 'package:task_manager/core/network/api_client.dart';

import '../models/reset_password_model.dart';

class ForgotPasswordRemoteDataSource {
  final ApiClient apiClient;

  ForgotPasswordRemoteDataSource(this.apiClient);

  Future<void> forgotPassword(String email) async {
    await apiClient.dio.post(
      "/forgot-password",
      data: {"email": email},
    );
  }

  Future<void> resetPassword(ResetPasswordModel model) async {
    await apiClient.dio.post(
      "/reset-password",
      data: model.toJson(),
    );
  }
}