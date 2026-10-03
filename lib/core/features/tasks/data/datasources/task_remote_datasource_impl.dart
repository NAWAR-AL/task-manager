import 'package:task_manager/core/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:task_manager/core/features/tasks/data/model/task_model.dart';
import 'package:task_manager/core/network/api_client.dart';

class TaskRemoteDatasourceImpl extends TaskRemoteDatasource {
  final ApiClient apiClient;

  TaskRemoteDatasourceImpl(this.apiClient);

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    final response = await apiClient.dio.post('/tasks', data: task.toJson());
    final responseData = response.data['data'] ?? response.data;
    return TaskModel.fromJson(Map<String, dynamic>.from(responseData));
  }

  @override
  Future<void> deleteTask(int id) async {
    print('delets tasks');
    await apiClient.dio.delete('/tasks/$id');
  }

  @override
  Future<TaskModel> getTaskById(int id) async {
    final response = await apiClient.dio.get('/task/$id');
    final responseData = response.data['data'] ?? response.data;
    return TaskModel.fromJson(Map<String, dynamic>.from(responseData));
  }

  @override
  Future<List<TaskModel>> getTasks() async {
    final response = await apiClient.dio.get('/tasks');
    final dynamic rawList = response.data['data'] ?? response.data;
    if (rawList is! List) {
      throw FormatException(
        'expected a list of tasks, but found : ${rawList.runtimeType}',
      );
    }
    return (rawList)
        .map((json) => TaskModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    final response = await apiClient.dio.put(
      '/tasks/${task.id}',
      data: task.toJson(),
    );
    final responseData = response.data['data'] ?? response.data;
    return TaskModel.fromJson(Map<String, dynamic>.from(responseData));
  }

  @override
  Future<TaskModel> updateTaskStatus(int taskId, String status) async {
    final response = await apiClient.dio.put('/task/$taskId/$status');
    final responseData = response.data['data'] ?? response.data;
    return TaskModel.fromJson(Map<String, dynamic>.from(responseData));
  }
}
