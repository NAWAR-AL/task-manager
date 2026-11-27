import 'package:task_manager/core/di/injection_container.dart';
import 'package:task_manager/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:task_manager/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_manager/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:task_manager/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:task_manager/features/auth/presentation/cubit/forgot_password_cubit.dart';

Future<void> initForgotPassword() async {
  // DataSource
  sl.registerLazySingleton<ForgotPasswordRemoteDataSource>(
    () => ForgotPasswordRemoteDataSource(sl()),
  );

  // Repository
  sl.registerLazySingleton<ForgotPasswordRepository>(
    () => ForgotPasswordRepositoryImpl(sl()),
  );

  // UseCases
  sl.registerLazySingleton<ForgotPasswordUsecase>(
    () => ForgotPasswordUsecase(sl()),
  );
  sl.registerLazySingleton<ResetPasswordUsecase>(
    () => ResetPasswordUsecase(sl()),
  );

  // Cubit
  sl.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(
      forgotPasswordUsecase: sl(),
      resetPasswordUsecase: sl(),
    ),
  );
}