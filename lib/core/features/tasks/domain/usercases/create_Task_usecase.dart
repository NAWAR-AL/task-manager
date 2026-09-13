import 'package:task_manager/core/features/tasks/domain/entities/task_entity.dart';
import 'package:task_manager/core/features/tasks/domain/repositories/task_repository.dart';

class CreatetaskUsecase {
  final TaskRepository repository;
  CreatetaskUsecase(this.repository);
  Future<TaskEntity> call(TaskEntity task) {
    if (task.title.trim().isEmpty) {
      throw Exception("the title cantnot be empty");
    }
    if (task.project_id <= 0) {
      throw Exception('please select a project');
    }
    if (task.priority.isEmpty) {
      throw Exception('please select a priority');
    }
    if (task.assigned_users.isEmpty) {
      throw Exception('please assgin at least one developer');
    }
    return repository.createTask(task);
  }
}
