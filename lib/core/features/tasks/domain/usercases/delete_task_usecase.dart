import 'package:task_manager/core/features/tasks/domain/repositories/task_repository.dart';

class DeletetaskUsecase {
  final TaskRepository repository;
  DeletetaskUsecase(this.repository);
  Future<void> call(int id) {
    return repository.deleteTask(id);
  }
}
