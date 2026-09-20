import '../entities/project.dart';
import '../repositories/project_repository.dart';

class GetProjectdetailsUsecases {
  final ProjectRepository repo;

  GetProjectdetailsUsecases({required this.repo});

  Future<ProjectEntity> call(int projectId) async {
    return await repo.getProjectDetails(projectId);
  }
}
