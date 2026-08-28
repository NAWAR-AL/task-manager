import 'package:flutter/material.dart';
import 'package:task_manager/core/features/auth/data/models/login_model.dart';
import 'package:task_manager/core/permission/role.dart';

class UserInfo extends StatelessWidget {
  final LoginModel user;
  final UserRole role;
  UserInfo({super.key, required this.role, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          child: Text(
            user.username.isNotEmpty ? user.username.toUpperCase() : role.name,
          ),
        ),
        Text(role.name, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
