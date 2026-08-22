import 'package:taskmanger/core/features/tasks/domain/entities/task_entity.dart';
import 'package:taskmanger/core/features/tasks/domain/repositories/task_repository.dart';

class GetTasksUsecase {
  final TaskRepository repository;
  GetTasksUsecase(this.repository);
  Future<List<TaskEntity>> call() {
    return repository.getTasks();
  }
}
