import 'package:task_manager/core/di/injection_container.dart';
import 'package:task_manager/core/features/auth/data/datasources/profile_remote_datasource.dart';
import 'package:task_manager/core/features/auth/data/repositories/profile_repository_impl.dart';
import 'package:task_manager/core/features/auth/domain/repositories/profile_repository.dart';
import 'package:task_manager/core/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:task_manager/core/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_cubit.dart';

Future<void> initProfile() async {
  sl.registerLazySingleton<ProfileRemoteDatasource>(
    () => ProfileRemoteDatasource(sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetProfileUsecase>(() => GetProfileUsecase(sl()));
  sl.registerLazySingleton<GetUsersUsecase>(() => GetUsersUsecase(sl()));
  sl.registerLazySingleton<ProfileCubit>(
    () => ProfileCubit(getProfileUsecase: sl(), getUsers: sl()),
  );
}
