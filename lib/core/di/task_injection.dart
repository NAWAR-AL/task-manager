import 'package:task_manager/core/di/injection_container.dart';
import 'package:task_manager/core/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:task_manager/core/features/tasks/data/datasources/task_remote_datasource_impl.dart';
import 'package:task_manager/core/features/tasks/data/repository/task_repository_impl.dart';
import 'package:task_manager/core/features/tasks/domain/repositories/task_repository.dart';
import 'package:task_manager/core/features/tasks/domain/usercases/create_Task_usecase.dart';
import 'package:task_manager/core/features/tasks/domain/usercases/deleteTask_usecase.dart';
import 'package:task_manager/core/features/tasks/domain/usercases/getTasks_usecase.dart';
import 'package:task_manager/core/features/tasks/domain/usercases/getbyId_usecase.dart';
import 'package:task_manager/core/features/tasks/domain/usercases/updateStatus_usecase.dart';
import 'package:task_manager/core/features/tasks/domain/usercases/updateTask_usecase.dart';
import 'package:task_manager/core/features/tasks/presentation/task_bloc/task_bloc.dart';

Future<void> initTask() async {
  sl.registerLazySingleton<TaskRemoteDatasource>(
    () => TaskRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(sl()));

  sl.registerLazySingleton(() => CreatetaskUsecase(sl()));
  sl.registerLazySingleton(() => GetTasksUsecase(sl()));
  sl.registerLazySingleton(() => GetbyidUsecase(sl()));
  sl.registerLazySingleton(() => UpdatetaskUsecase(sl()));
  sl.registerLazySingleton(() => DeletetaskUsecase(sl()));
  sl.registerLazySingleton(() => UpdatestatusUsecase(sl()));
  sl.registerLazySingleton(
    () => TaskBloc(
      createtaskUsecase: sl(),
      getTasksUsecase: sl(),
      deletetaskUsecase: sl(),
      updatetaskUsecase: sl(),
    ),
  );
}
