part of 'task_bloc.dart';

@immutable
abstract class TaskEvent {}

class GetTasks extends TaskEvent {
  final List<TaskEntity> tasks;
  GetTasks(this.tasks);
}

class CreateTask extends TaskEvent {
  final TaskEntity task;
  CreateTask(this.task);
}

class UpdateTask extends TaskEvent {
  final TaskEntity task;
  UpdateTask(this.task);
}

class GetoneTask extends TaskEvent {
  final int id;
  GetoneTask(this.id);
}

class DeleteTask extends TaskEvent {
  final int id;
  DeleteTask(this.id);
}

class UpdateTaskStatus extends TaskEvent {
  final int id;
  final String status;
  UpdateTaskStatus(this.id, this.status);
}
