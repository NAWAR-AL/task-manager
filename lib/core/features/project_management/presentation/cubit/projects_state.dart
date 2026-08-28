import '../../domain/entities/project.dart';

abstract class ProjectsState {}

class ProjectsInitial extends ProjectsState {}

class ProjectsLoading extends ProjectsState {}

class ProjectsLoaded extends ProjectsState {
  final List<Project> projects;

  ProjectsLoaded(this.projects);
}

class ProjectsError extends ProjectsState {
  final String message;

  ProjectsError(this.message);
}

class ProjectInitial extends ProjectsState {}

class ProjectLoading extends ProjectsState {}

class ProjectLoaded extends ProjectsState {
  final Project project;

  ProjectLoaded(this.project);
}

class ProjectError extends ProjectsState {
  final String message;

  ProjectError(this.message);
}

class ProjectCreated extends ProjectsState {}

class ProjectUpdated extends ProjectsState {}

class ProjectDeleted extends ProjectsState {}