import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../features/auth/data/datasources/logout_remote_datasource.dart';
import '../features/auth/data/repositories/logout_repository_impl.dart';
import '../features/auth/domain/repositories/logout_repository.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/presentation/cubit/logout_cubit.dart';

final getIt = GetIt.instance;

void logoutInjection() {
  // Data Source
  getIt.registerLazySingleton<LogoutRemoteDataSource>(
    () => LogoutRemoteDataSource(
      getIt<Dio>(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<LogoutRepository>(
    () => LogoutRepositoryImpl(
      getIt<LogoutRemoteDataSource>(),
    ),
  );

  // Use Case
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(
      getIt<LogoutRepository>(),
    ),
  );

  // Cubit
  getIt.registerFactory<LogoutCubit>(
    () => LogoutCubit(
      getIt<LogoutUseCase>(),
    ),
  );
}