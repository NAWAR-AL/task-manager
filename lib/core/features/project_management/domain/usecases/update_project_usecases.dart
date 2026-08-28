import '../entities/project.dart';
import '../repositories/project_repository.dart';

class UpdateProjectUsecases {
  final ProjectRepository repo;

  UpdateProjectUsecases({required this.repo});

  Future<void> call(Project project ) async {
    return await repo.createProject(project);
  }
}
