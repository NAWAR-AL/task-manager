import 'package:task_manager/core/network/api_client.dart';
import '../models/project_model.dart';

class ProjectRemoteDatasource {
  final ApiClient apiClient;

  ProjectRemoteDatasource(this.apiClient);

  Future<List<ProjectModel>> getProjects() async {
    final response = await apiClient.dio.get(
      "https://jsonplaceholder.typicode.com",
    );

    return (response.data as List)
        .map((e) => ProjectModel.fromJson(e))
        .toList();
  }

  Future<ProjectModel> getProject(int id) async {
    final response = await apiClient.dio.get("");

    return ProjectModel.fromJson(response.data);
  }

  Future<void> createdProject(ProjectModel project) async {
    await apiClient.dio.post("");
  }

  Future<void> updateProject(ProjectModel project) async {
    await apiClient.dio.put("", data: project.toJson());
  }

  Future<void> deleteProject(int id) async {
    await apiClient.dio.delete("");
  }
}
