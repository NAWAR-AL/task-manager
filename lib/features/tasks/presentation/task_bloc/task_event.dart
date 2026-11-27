part of 'task_bloc.dart';

@immutable
abstract class TaskEvent {}

class GetTasks extends TaskEvent {}

class CreateTaskEvent extends TaskEvent {
  final TaskEntity task;
  CreateTaskEvent(this.task);
}

class UpdateTaskEvent extends TaskEvent {
  final TaskEntity task;
  UpdateTaskEvent(this.task);
}

class GetoneTaskEvent extends TaskEvent {
  final int id;
  GetoneTaskEvent(this.id);
}

class DeleteTaskEvent extends TaskEvent {
  final int id;
  DeleteTaskEvent(this.id);
}

class UpdateTaskStatusEvent extends TaskEvent {
  final int id;
  final String status;
  UpdateTaskStatusEvent(this.id, this.status);
}
