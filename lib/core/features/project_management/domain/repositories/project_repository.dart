import '../entities/project.dart';

abstract class ProjectRepository {
  Future<List<Project>> getProjects();

  Future<Project> getProject(int id);

  Future<void> createProject(Project project);

  Future<void> updateProject(Project project);

  Future<void> deleteProject(int id);
}
