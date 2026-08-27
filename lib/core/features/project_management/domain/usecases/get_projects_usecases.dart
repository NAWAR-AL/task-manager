import '../entities/project.dart';
import '../repositories/project_repository.dart';

class GetProjectsUsecases {
  final ProjectRepository repo;

  GetProjectsUsecases({required this.repo});

  Future<List<Project>> call() async {
    return await repo.getProjects();
  }
}
