class ResetPasswordModel {
  final String token;
  final String email;
  final String password;
  final String passwordConfirmation;

  ResetPasswordModel({
    required this.token,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
    };
  }
}