import 'package:task_manager/core/features/users_mangment/domain/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.password,
    required super.role,
    required super.username,
  });
}
