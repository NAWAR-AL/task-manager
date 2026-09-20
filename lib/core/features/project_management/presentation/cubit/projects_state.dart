import '../../domain/entities/project.dart';

abstract class ProjectsState {}

class ProjectsInitial extends ProjectsState {}

class ProjectsLoading extends ProjectsState {}

class ProjectsLoaded extends ProjectsState {
  final List<ProjectEntity> projects;

  ProjectsLoaded(this.projects);
}

class ProjectsError extends ProjectsState {
  final String message;

  ProjectsError(this.message);
}

class ProjectInitial extends ProjectsState {}

class ProjectLoading extends ProjectsState {}

class ProjectLoaded extends ProjectsState {
  final ProjectEntity project;

  ProjectLoaded(this.project);
}

class ProjectError extends ProjectsState {
  final String message;

  ProjectError(this.message);
}

class ProjectCreated extends ProjectsState {}

class ProjectUpdated extends ProjectsState {}

class ProjectDeleted extends ProjectsState {}

class GetProjectDetailesLoaded extends ProjectsState {
  final ProjectEntity project;

  GetProjectDetailesLoaded(this.project);
}
