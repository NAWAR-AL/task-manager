import 'package:taskmanger/core/features/tasks/domain/entities/task_entity.dart';
import 'package:taskmanger/core/features/tasks/domain/repositories/task_repository.dart';

class UpdatestatusUsecase {
  final TaskRepository repository;
  UpdatestatusUsecase(this.repository);
  Future<TaskEntity> call(TaskEntity task) {
    if (task.status.isEmpty) {
      throw Exception("the status cannot be empty");
    }
    return repository.updateTaskStatus(task.id, task.status);
  }
}
