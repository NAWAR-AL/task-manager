import 'package:taskmanger/core/features/tasks/domain/entities/task_entity.dart';
import 'package:taskmanger/core/features/tasks/domain/repositories/task_repository.dart';

class GetbyidUsecase {
  final TaskRepository repository;
  GetbyidUsecase(this.repository);
  Future<TaskEntity> call(int id) {
    return repository.getTaskById(id);
  }
}
