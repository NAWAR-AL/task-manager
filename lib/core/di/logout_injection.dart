import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:task_manager/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:task_manager/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';

import 'package:task_manager/features/auth/domain/usecases/logout_usecase.dart';
import 'package:task_manager/features/auth/presentation/cubit/logout_cubit.dart';

final getIt = GetIt.instance;

void logoutInjection() {
  // Data Source
  getIt.registerLazySingleton<LogoutRemoteDataSource>(
    () => LogoutRemoteDataSource(getIt<Dio>()),
  );

  // Repository
  getIt.registerLazySingleton<LogoutRepository>(
    () => LogoutRepositoryImpl(getIt<LogoutRemoteDataSource>()),
  );

  // Use Case
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<LogoutRepository>()),
  );

  // Cubit
  getIt.registerFactory<LogoutCubit>(() => LogoutCubit(getIt<LogoutUseCase>()));
}
