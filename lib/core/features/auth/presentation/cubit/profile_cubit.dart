import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/auth/domain/usecases/get_user_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUsecase getProfileUsecase;
  final GetUsersUsecase getUsers;

  ProfileCubit({required this.getProfileUsecase, required this.getUsers})
    : super(UserInial());

  Future<void> fetchProfile() async {
    emit(UserLoading());

    try {
      final profile = await getProfileUsecase();
      emit(UserLoaded(profile));
    } catch (e) {
      emit(UserErorr(e.toString()));
    }
  }

  Future<void> getusers() async {
    emit(UserLoading());
    try {
      final users = await getUsers();
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UserErorr(e.toString()));
    }
  }
}
