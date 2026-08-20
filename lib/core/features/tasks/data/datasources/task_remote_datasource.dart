

import 'package:taskmanger/core/features/tasks/data/model/task_model.dart';

abstract class TaskRemoteDatasource {
  Future<TaskModel> createTask(TaskModel task);
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> updateTask(TaskModel task);
  Future<TaskModel> getTaskById(int id);
  Future<void> deleteTask(int id);
  Future<TaskModel> updateTaskStatus(int taskId, String status);
}
