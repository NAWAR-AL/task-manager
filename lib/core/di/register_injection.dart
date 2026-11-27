import 'package:task_manager/core/di/injection_container.dart';
import 'package:task_manager/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:task_manager/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_manager/features/auth/domain/usecases/register_usecases.dart';
import 'package:task_manager/features/auth/presentation/cubit/register_cubit.dart';

Future<void> initRegister() async {
  // DataSource
  sl.registerLazySingleton<RegisterRemoteDatasource>(
    () => RegisterRemoteDatasource(sl()),
  );

  // Repository
  sl.registerLazySingleton<RegisterRepository>(
    () => RegisterRepositoryImpl(sl()),
  );

  // UseCase
  sl.registerLazySingleton<RegisterUsecase>(() => RegisterUsecase(sl()));

  // Cubit
  sl.registerFactory<RegisterCubit>(() => RegisterCubit(sl()));
}
