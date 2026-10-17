import '../repositories/forgot_password_repository.dart';

class ForgotPasswordUsecase {
  final ForgotPasswordRepository repository;

  ForgotPasswordUsecase(this.repository);

  Future<void> call(String email) async {
    await repository.forgot(email);
  }
}