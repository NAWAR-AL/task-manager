import '../repositories/project_repository.dart';
import '../../domain/entities/project.dart';

class CreateProjectUsecases {
  final ProjectRepository repo;

  CreateProjectUsecases({required this.repo});

  Future<void> call(ProjectEntity project) async {
    return await repo.createProject(project);
  }
}
