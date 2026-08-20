import 'package:taskmanger/core/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:taskmanger/core/features/tasks/data/model/task_model.dart';
import 'package:taskmanger/core/features/tasks/domain/entities/task_entity.dart';
import 'package:taskmanger/core/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl extends TaskRepository {
  final TaskRemoteDatasource datasource;
  TaskRepositoryImpl(this.datasource);
  @override
  Future<TaskEntity> createTask(TaskEntity task) async {
    final taskModel = TaskModel.fromEntity(task);
    final result = await datasource.createTask(taskModel);

    return result;
  }

  @override
  Future<void> deleteTask(int id) async {
    return await datasource.deleteTask(id);
  }

  @override
  Future<TaskEntity> getTaskById(int id) async {
    final result = await datasource.getTaskById(id);
    return result;
  }

  @override
  Future<List<TaskEntity>> getTasks() async {
    final result = await datasource.getTasks();
    return result;
  }

  @override
  Future<TaskEntity> updateTask(TaskEntity task) async {
    final taskModel = TaskModel.fromEntity(task);
    final result = await datasource.updateTask(taskModel);
    return result;
  }

  @override
  Future<TaskEntity> updateTaskStatus(int taskId, String status) async {
    final result = await datasource.updateTaskStatus(taskId, status);
    return result;
  }
}
