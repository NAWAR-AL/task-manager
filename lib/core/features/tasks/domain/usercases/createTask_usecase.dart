

import 'package:taskmanger/core/features/tasks/domain/entities/task_entity.dart';
import 'package:taskmanger/core/features/tasks/domain/repositories/task_repository.dart';

class CreatetaskUsecase {
  final TaskRepository repository;
  CreatetaskUsecase(this.repository);
  Future<TaskEntity> call(TaskEntity task) {
    if (task.title.isEmpty&& task.description.isEmpty) {
      throw Exception("the title cantnot be empty");
    }
    return repository.createTask(task);
  }
}
