import 'package:task_manager/core/features/auth/data/datasources/forgot_password_remote_data_source.dart';
import 'package:task_manager/core/features/auth/data/models/reset_password_model.dart';
import 'package:task_manager/core/features/auth/domain/entities/reset_password.dart';

import '../../domain/repositories/forgot_password_repository.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final ForgotPasswordRemoteDataSource remote;

  ForgotPasswordRepositoryImpl(this.remote);

  @override
  Future<void> forgot(String email) async {
    await remote.forgotPassword(email);
  }

  @override
  Future<void> reset(ResetPassword params) async {
    final model = ResetPasswordModel(
      token: params.token,
      email: params.email,
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
    );
    await remote.resetPassword(model);
  }
}