class RegisterModel {
  final String name;
  final String email;
  final String password;
  final String password_confirmation;

  RegisterModel({
    required this.name,
    required this.email,
    required this.password,
    required this.password_confirmation
  }); // شكل البيانات داخل التطبيق

  Map<String, dynamic> toJson() {
    return {"name": name, "email": email, "password": password, "password_confirmation": password_confirmation};
  }

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      name: json["name"],
      email: json["email"],
      password: json["password"],
      password_confirmation: json["password_confirmation"],
    );
  }
}
