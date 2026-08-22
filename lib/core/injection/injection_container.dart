import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:taskmanger/core/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:taskmanger/core/features/tasks/data/datasources/task_remote_datasource_impl.dart';
import 'package:taskmanger/core/features/tasks/data/repository/task_repository_impl.dart';
import 'package:taskmanger/core/features/tasks/domain/repositories/task_repository.dart';
import 'package:taskmanger/core/features/tasks/domain/usercases/createTask_usecase.dart';
import 'package:taskmanger/core/features/tasks/domain/usercases/deleteTask_usecase.dart';
import 'package:taskmanger/core/features/tasks/domain/usercases/getTasks_usecase.dart';
import 'package:taskmanger/core/features/tasks/domain/usercases/getbyId_usecase.dart';
import 'package:taskmanger/core/features/tasks/domain/usercases/updateStatus_usecase.dart';
import 'package:taskmanger/core/features/tasks/domain/usercases/updateTask_usecase.dart';
import 'package:taskmanger/core/features/tasks/presentation/task_bloc/task_bloc.dart';

final gitIt = GetIt.instance;
Future<void> setServicesInjection() async {
  gitIt.registerLazySingleton(() => Dio());
  gitIt.registerLazySingleton<TaskRemoteDatasource>(
    () => TaskRemoteDatasourceImpl(gitIt()),
  );
  gitIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(gitIt()),
  );
  gitIt.registerLazySingleton(() => CreatetaskUsecase(gitIt()));
  gitIt.registerLazySingleton(() => GetTasksUsecase(gitIt()));
  gitIt.registerLazySingleton(() => GetbyidUsecase(gitIt()));
  gitIt.registerLazySingleton(() => UpdatetaskUsecase(gitIt()));
  gitIt.registerLazySingleton(() => DeletetaskUsecase(gitIt()));
  gitIt.registerLazySingleton(() => UpdatestatusUsecase(gitIt()));
  gitIt.registerLazySingleton(
    () => TaskBloc(
      createtaskUsecase: gitIt(),
      getTasksUsecase: gitIt(),
      deletetaskUsecase: gitIt(),
      updatetaskUsecase: gitIt(),
    ),
  );    
}
