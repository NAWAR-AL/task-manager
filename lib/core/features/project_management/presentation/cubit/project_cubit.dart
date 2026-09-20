import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/project_management/domain/usecases/get_projectdetails_usecases.dart';
import '../../domain/usecases/get_projects_usecases.dart';
import '../../domain/usecases/get_project_usecases.dart';
import '../../domain/usecases/create_project_usecases.dart';
import '../../domain/usecases/update_project_usecases.dart';
import '../../domain/usecases/delete_projects_usecases.dart';
import '../../domain/entities/project.dart';
import 'projects_state.dart';

class ProjectCubit extends Cubit<ProjectsState> {
  final GetProjectsUsecases getProjectsUsecases;
  final GetProjectUsecases getProjectUsecases;
  final CreateProjectUsecases createProjectUsecases;
  final UpdateProjectUsecases updateProjectUsecases;
  final DeleteProjectsUsecases deleteProjectsUsecases;
  final GetProjectdetailsUsecases getProjectdetailsUsecases;

  ProjectCubit({
    required this.getProjectsUsecases,
    required this.getProjectUsecases,
    required this.createProjectUsecases,
    required this.updateProjectUsecases,
    required this.deleteProjectsUsecases,
    required this.getProjectdetailsUsecases,
  }) : super(ProjectInitial());

  Timer? debounce;

  Future<void> fetchProjects() async {
    emit(ProjectsLoading());

    try {
      final projects = await getProjectsUsecases();
      emit(ProjectsLoaded(projects));
    } catch (e) {
      emit(ProjectsError(e.toString()));
    }
  }

  Future<void> fetchProject(int id) async {
    print('fetch projects is called');
    emit(ProjectLoading());

    try {
      final project = await getProjectUsecases(id);
      emit(ProjectLoaded(project));
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
    print('fetch projects finished work');
  }

  Future<void> createProject(ProjectEntity project) async {
    try {
      await createProjectUsecases(project);
      emit(ProjectCreated());
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> updateProject(ProjectEntity project, int id) async {
    try {
      await updateProjectUsecases(project);
      emit(ProjectUpdated());
      await fetchProject(id);
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> deleteProject(int id) async {
    try {
      await deleteProjectsUsecases(id);
      emit(ProjectDeleted());
      await fetchProjects();
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> getProjectDetails(int projectId) async {
    emit(ProjectLoading());

    try {
      final project = await getProjectdetailsUsecases(projectId);
      emit(GetProjectDetailesLoaded(project));
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }
}
