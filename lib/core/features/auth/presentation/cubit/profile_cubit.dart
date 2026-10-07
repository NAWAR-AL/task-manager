import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/auth/domain/entities/register.dart';
import 'package:task_manager/core/features/auth/domain/usecases/create_user_usecase.dart';
import 'package:task_manager/core/features/auth/domain/usecases/get_single_user_usecase.dart';
import 'package:task_manager/core/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:task_manager/core/features/auth/domain/usecases/get_userdashboard_usecase.dart';
import 'package:task_manager/core/features/auth/domain/usecases/update_user_role_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUsecase getProfileUsecase;
  final GetUsersUsecase getUsers;
  final GetDashboardUsersUsecase getDashboardUsersUsecase;
  final GetSingleUserUsecase getSingleUserUsecase;
  final CreateUserUsecase createUserUsecase;
  final UpdateUserRoleUsecase updateUserRoleUsecase;

  ProfileCubit({
    required this.getProfileUsecase,
    required this.getUsers,
    required this.getDashboardUsersUsecase,
    required this.getSingleUserUsecase,
    required this.createUserUsecase,
    required this.updateUserRoleUsecase,
  }) : super(UserInial());

  Future<void> fetchProfile() async {
    emit(UserLoading());

    try {
      final profile = await getProfileUsecase();
      emit(UserLoaded(profile));
    } catch (e) {
      emit(UserErorr(e.toString()));
    }
  }

  Future<void> getDashboardusers() async {
    emit(UserLoading());
    try {
      final users = await getDashboardUsersUsecase();
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UserErorr(e.toString()));
    }
  }

  Future<void> fetchUsers() async {
    emit(UserLoading());
    try {
      final users = await getUsers();
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UserErorr(e.toString()));
    }
  }

  Future<void> fetchUser(int id) async {
    emit(UserLoading());
    try {
      final user = await getSingleUserUsecase(id);
      emit(SingleUserLoaded(user));
    } catch (e) {
      emit(UserErorr(e.toString()));
    }
  }

  Future<void> createUser(Register register) async {
    try {
      await createUserUsecase(register);
      emit(UserCreated());
      await fetchUsers();
    } catch (e) {
      emit(UserErorr(e.toString()));
    }
  }

  Future<void> updateUserRole(int userId, String role) async {
    try {
      await updateUserRoleUsecase(userId, role);
      emit(UserRoleUpdated());
      // نعيّد جلب القائمة حتى يتحدث الشارة فوراً
      await fetchUsers();
    } catch (e) {
      emit(UserErorr(e.toString()));
    }
  }
}