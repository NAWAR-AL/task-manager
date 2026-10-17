class ResetPassword {
  final String token;
  final String email;
  final String password;
  final String passwordConfirmation;

  ResetPassword({
    required this.token,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });
}   