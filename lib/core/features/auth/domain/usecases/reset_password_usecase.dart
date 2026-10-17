import '../entities/reset_password.dart';
import '../repositories/forgot_password_repository.dart';

class ResetPasswordUsecase {
  final ForgotPasswordRepository repository;

  ResetPasswordUsecase(this.repository);

  Future<void> call(ResetPassword params) async {
    await repository.reset(params);
  }
}