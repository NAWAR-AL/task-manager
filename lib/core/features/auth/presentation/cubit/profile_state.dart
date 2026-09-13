import '../../domain/entities/user.dart';

abstract class ProfileState {}

class UserInial extends ProfileState {}

class UserLoading extends ProfileState {}

class UserLoaded extends ProfileState {
  final User user;

  UserLoaded(this.user);
}

class UserErorr extends ProfileState {
  final String message;

  UserErorr(this.message);
}
