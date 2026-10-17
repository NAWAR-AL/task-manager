import '../entities/reset_password.dart';

abstract class ForgotPasswordRepository {
  Future<void> forgot(String email);

  Future<void> reset(ResetPassword params);
}