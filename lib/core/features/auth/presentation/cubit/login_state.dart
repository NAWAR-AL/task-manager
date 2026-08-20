abstract class LoginState {}

class LoginInial extends LoginState {}

class LoginLaoding extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String massage;

  LoginFailure(this.massage);
}