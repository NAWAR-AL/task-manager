import '../entities/project.dart';
import '../repositories/project_repository.dart';

class GetProjectUsecases {
  final ProjectRepository repo;

  GetProjectUsecases({required this.repo});

  Future<Project> call(int id) async {
    return await repo.getProject(id);
  }
}
