import 'package:task_manager/core/permission/role.dart';

abstract class LoginState {}

class LoginInial extends LoginState {}

class LoginLaoding extends LoginState {}

class LoginSuccess extends LoginState {
  final UserRole role;
  LoginSuccess(this.role);
}

class LoginFailure extends LoginState {
  final String massage;

  LoginFailure(this.massage);
}
