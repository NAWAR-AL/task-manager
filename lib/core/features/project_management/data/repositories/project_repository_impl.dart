import 'package:task_manager/core/features/project_management/domain/entities/project.dart';
import 'package:task_manager/core/features/project_management/domain/repositories/project_repository.dart';
import '../datasources/project_remote_datasource.dart';
import '../models/project_model.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDatasource remote;

  ProjectRepositoryImpl(this.remote);

  @override
  Future<List<ProjectEntity>> getProjects() async {
    return await remote.getProjects();
  }

  @override
  Future<ProjectEntity> getProject(int id) async {
    return await remote.getProject(id);
  }

  @override
  Future<void> createProject(ProjectEntity project) async {
    final model = ProjectModel(
      id: project.id,
      name: project.name,
      description: project.description,
      status: project.status,
      createdBy: project.createdBy,
      createdAt: project.createdAt,
      updatedAt: project.updatedAt,
    );
    await remote.createdProject(model);
  }

  @override
  Future<void> updateProject(ProjectEntity project) async {
    final model = ProjectModel(
      id: project.id,
      name: project.name,
      description: project.description,
      status: project.status,
      createdBy: project.createdBy,
      createdAt: project.createdAt,
      updatedAt: project.updatedAt,
    );
    await remote.updateProject(model);
  }

  @override
  Future<void> deleteProject(int id) async {
    await remote.deleteProject(id);
  }
}
