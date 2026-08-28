import '../repositories/project_repository.dart';

class DeleteProjectsUsecases {
  final ProjectRepository repo;
  DeleteProjectsUsecases({required this.repo});

  Future<void> call(int id) async {
    return await repo.deleteProject(id);
  }
}
