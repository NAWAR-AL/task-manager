import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.email_verified_at,
    required super.created_at,
    required super.updated_at,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      role: json["role"],
      email_verified_at: json["email_verified_at"] != null
          ? DateTime.parse(json["email_verified_at"])
          : null,
      created_at: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : null,
      updated_at: json["updated_at"] != null
          ? DateTime.parse(json["updated_at"])
          : null,
    );
  }
}