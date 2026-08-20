
import 'package:dio/dio.dart';
import 'package:taskmanger/core/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:taskmanger/core/features/tasks/data/model/task_model.dart';

class TaskRemoteDatasourceImpl extends TaskRemoteDatasource {
  final Dio dio;
  TaskRemoteDatasourceImpl(this.dio);

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    final response = await dio.post('/tasks', data: task.toJson());
    return TaskModel.fromJson(response.data);
  }

  @override
  Future<void> deleteTask(int id) async {
    await dio.delete('/task/$id');
  }

  @override
  Future<TaskModel> getTaskById(int id) async {
    final response = await dio.get('/task/{$id}');
    return TaskModel.fromJson(response.data);
  }

  @override
  Future<List<TaskModel>> getTasks() async {
    final response = await dio.get('/tasks');
    return (response.data as List)
        .map((json) => TaskModel.fromJson(json))
        .toList();
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    final response = await dio.put('/task/${task.id},data:task.tojson()');
    return TaskModel.fromJson(response.data);
  }

  @override
  Future<TaskModel> updateTaskStatus(int taskId, String status) async {
    final response = await dio.put('/task/$taskId/$status');
    return (TaskModel.fromJson(response.data));
  }
}
