
import 'package:task_manager/core/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:task_manager/core/features/tasks/data/model/task_model.dart';
import 'package:task_manager/core/network/api_client.dart';

class TaskRemoteDatasourceImpl extends TaskRemoteDatasource {
  final ApiClient apiClient;

  TaskRemoteDatasourceImpl(this.apiClient);

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    final response = await apiClient.dio.post('/tasks', data: task.toJson());
    return TaskModel.fromJson(response.data);
  }

  @override
  Future<void> deleteTask(int id) async {
    await apiClient.dio.delete('/task/$id');
  }

  @override
  Future<TaskModel> getTaskById(int id) async {
    final response = await apiClient.dio.get('/task/{$id}');
    return TaskModel.fromJson(response.data);
  }

  @override
  Future<List<TaskModel>> getTasks() async {
    final response = await apiClient.dio.get('/tasks');
    return (response.data as List)
        .map((json) => TaskModel.fromJson(json))
        .toList();
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    final response = await apiClient.dio.put(
      '/task/${task.id},data:task.tojson()',
    );
    return TaskModel.fromJson(response.data);
  }

  @override
  Future<TaskModel> updateTaskStatus(int taskId, String status) async {
    final response = await apiClient.dio.put('/task/$taskId/$status');
    return (TaskModel.fromJson(response.data));
  }
}
