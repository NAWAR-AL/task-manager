import 'package:task_manager/core/di/injection_container.dart';
import 'package:task_manager/core/features/project_management/data/datasources/project_remote_datasource.dart';
import 'package:task_manager/core/features/project_management/data/repositories/project_repository_impl.dart';
import 'package:task_manager/core/features/project_management/domain/repositories/project_repository.dart';
import 'package:task_manager/core/features/project_management/domain/usecases/create_project_usecases.dart';
import 'package:task_manager/core/features/project_management/domain/usecases/delete_projects_usecases.dart';
import 'package:task_manager/core/features/project_management/domain/usecases/get_project_usecases.dart';
import 'package:task_manager/core/features/project_management/domain/usecases/get_projects_usecases.dart';
import 'package:task_manager/core/features/project_management/domain/usecases/update_project_usecases.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/project_cubit.dart';

Future<void> initProject() async {
  sl.registerLazySingleton<ProjectRemoteDatasource>(
    () => ProjectRemoteDatasource(sl()),
  );
  sl.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetProjectUsecases>(
    () => GetProjectUsecases(repo: sl()),
  );
  sl.registerLazySingleton<GetProjectsUsecases>(
    () => GetProjectsUsecases(repo: sl()),
  );
  sl.registerLazySingleton<CreateProjectUsecases>(
    () => CreateProjectUsecases(repo: sl()),
  );
  sl.registerLazySingleton<UpdateProjectUsecases>(
    () => UpdateProjectUsecases(repo: sl()),
  );
  sl.registerLazySingleton<DeleteProjectsUsecases>(
    () => DeleteProjectsUsecases(repo: sl()),
  );
  sl.registerLazySingleton<ProjectCubit>(
    () => ProjectCubit(
      getProjectsUsecases: sl(),
      getProjectUsecases: sl(),
      createProjectUsecases: sl(),
      updateProjectUsecases: sl(),
      deleteProjectsUsecases: sl(),
    ),
  );
}
