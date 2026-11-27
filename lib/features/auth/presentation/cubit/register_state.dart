

abstract class RegisterState {}

class RegisterInial extends RegisterState{}

class RegisterLoading extends RegisterState{}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String message;

  RegisterFailure(this.message);
}

