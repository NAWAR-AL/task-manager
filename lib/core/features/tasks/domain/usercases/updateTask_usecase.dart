import 'package:taskmanger/core/features/tasks/domain/entities/task_entity.dart';
import 'package:taskmanger/core/features/tasks/domain/repositories/task_repository.dart';

class UpdatetaskUsecase {
  final TaskRepository repository;
  UpdatetaskUsecase(this.repository);
  Future<TaskEntity> call(TaskEntity task) {
    if (task.description.isEmpty) {
      throw Exception("please explain the update in the description");
    }
    return repository.updateTask(task);
  }
}
