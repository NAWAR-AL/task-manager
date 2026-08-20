import 'package:task_manager/core/di/injection_container.dart';
import 'package:task_manager/core/features/auth/data/datasources/login_remote_data_source.dart';
import 'package:task_manager/core/features/auth/data/repositories/login_repository_impl.dart';
import 'package:task_manager/core/features/auth/domain/repositories/login_repository.dart';
import 'package:task_manager/core/features/auth/domain/usecases/login_usecases.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/login_cubit.dart';

Future<void> initLogin() async {
  sl.registerLazySingleton<LoginRemoteDatasource>(
    () => LoginRemoteDatasource(sl()),
  );

  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(sl()));

  sl.registerLazySingleton<LoginUsecase>(() => LoginUsecase(sl()));

  sl.registerFactory<LoginCubit>(() => LoginCubit(sl()));
}
