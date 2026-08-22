import 'package:taskmanger/core/features/tasks/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<TaskEntity> getTaskById(int id);
  Future<List<TaskEntity>> getTasks();
  Future<TaskEntity> createTask(TaskEntity task);
  Future<TaskEntity> updateTask(TaskEntity task);
  Future<void> deleteTask(int id);
  Future<TaskEntity> updateTaskStatus(int taskId, String status);
}
