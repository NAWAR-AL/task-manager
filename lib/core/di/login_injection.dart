import 'package:task_manager/core/di/injection_container.dart';
import 'package:task_manager/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:task_manager/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_manager/features/auth/domain/usecases/login_usecases.dart';
import 'package:task_manager/features/auth/presentation/cubit/login_cubit.dart';

Future<void> initLogin() async {
  sl.registerLazySingleton<LoginRemoteDatasource>(
    () => LoginRemoteDatasource(sl()),
  );

  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(sl()));

  sl.registerLazySingleton<LoginUsecase>(() => LoginUsecase(sl()));

  sl.registerFactory<LoginCubit>(() => LoginCubit(sl()));
}
