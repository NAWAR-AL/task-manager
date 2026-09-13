import 'package:task_manager/core/network/api_client.dart';
import '../models/project_model.dart';

class ProjectRemoteDatasource {
  final ApiClient apiClient;

  ProjectRemoteDatasource(this.apiClient);

  Future<List<ProjectModel>> getProjects() async {
    final response = await apiClient.dio.get(
      "https://taskback.orbit-eng.net/api/projects",
    );
    final List projectsData = response.data['data'];
    return projectsData.map((e) => ProjectModel.fromJson(e)).toList();
    // return (response.data as List)
    //     .map((e) => ProjectModel.fromJson(e))
    //     .toList();
  }

  Future<ProjectModel> getProject(int id) async {
    final response = await apiClient.dio.get("/projects/$id");

    return ProjectModel.fromJson(response.data);
  }

  Future<int?> createdProject(ProjectModel project) async {
    final response = await apiClient.dio.post(
      "https://taskback.orbit-eng.net/api/projects",
      data: project.toJson(),
    );
    return response.statusCode;
  }

  Future<void> updateProject(ProjectModel project) async {
    await apiClient.dio.put("/projects/${project.id}", data: project.toJson());
  }

  Future<void> deleteProject(int id) async {
    await apiClient.dio.delete("/projects/$id");
  }
}
