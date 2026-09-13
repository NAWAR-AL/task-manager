import '../entities/project.dart';

abstract class ProjectRepository {
  Future<List<ProjectEntity>> getProjects();

  Future<ProjectEntity> getProject(int id);

  Future<void> createProject(ProjectEntity project);

  Future<void> updateProject(ProjectEntity project);

  Future<void> deleteProject(int id);
}
