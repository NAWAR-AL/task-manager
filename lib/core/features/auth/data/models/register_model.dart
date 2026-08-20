class RegisterModel {
  final String username;
  final String email;
  final String password;

  RegisterModel({
    required this.username,
    required this.email,
    required this.password,
  }); // شكل البيانات داخل التطبيق

  Map<String, dynamic> toJson() {
    return {"username": username, "email": email, "password": password};
  }

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      username: json["usernamr"],
      email: json["email"],
      password: json["password"],
    );
  }
}
