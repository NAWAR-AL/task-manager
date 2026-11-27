import 'package:task_manager/core/di/injection_container.dart';
import 'package:task_manager/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:task_manager/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_manager/features/auth/domain/usecases/create_user_usecase.dart';
import 'package:task_manager/features/auth/domain/usecases/delete_user_usecase.dart';
import 'package:task_manager/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:task_manager/features/auth/domain/usecases/get_single_user_usecase.dart';
import 'package:task_manager/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:task_manager/features/auth/domain/usecases/get_userdashboard_usecase.dart';
import 'package:task_manager/features/auth/domain/usecases/udate_user_usercase.dart';
import 'package:task_manager/features/auth/domain/usecases/update_user_role_usecase.dart';
import 'package:task_manager/features/auth/presentation/cubit/profile_cubit.dart';

Future<void> initProfile() async {
  sl.registerLazySingleton<ProfileRemoteDatasource>(
    () => ProfileRemoteDatasource(sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetProfileUsecase>(() => GetProfileUsecase(sl()));
  sl.registerLazySingleton<GetUsersUsecase>(() => GetUsersUsecase(sl()));
  sl.registerLazySingleton<GetDashboardUsersUsecase>(
    () => GetDashboardUsersUsecase(sl()),
  );
  sl.registerLazySingleton<GetSingleUserUsecase>(
    () => GetSingleUserUsecase(sl()),
  );
  sl.registerLazySingleton<CreateUserUsecase>(() => CreateUserUsecase(sl()));
  sl.registerLazySingleton<UpdateUserRoleUsecase>(
    () => UpdateUserRoleUsecase(sl()),
  );
  sl.registerLazySingleton<DeleteUserUsecase>(() => DeleteUserUsecase(sl()));
  sl.registerLazySingleton<UpdateUserUsercase>(() => UpdateUserUsercase(sl()));
  sl.registerLazySingleton<ProfileCubit>(
    () => ProfileCubit(
      getProfileUsecase: sl(),
      getUsers: sl(),
      getDashboardUsersUsecase: sl(),
      getSingleUserUsecase: sl(),
      createUserUsecase: sl(),
      updateUserRoleUsecase: sl(),
      deleteUserUsecase: sl(),
      updateUserUsercase: sl(),
    ),
  );
}
