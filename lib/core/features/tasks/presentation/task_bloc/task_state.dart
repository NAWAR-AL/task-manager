part of 'task_bloc.dart';

@immutable
abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskCreated extends TaskState {
  final TaskEntity task; 
  TaskCreated(this.task); 
}

class TaskUpdated extends TaskState {
  final TaskEntity task; 
  TaskUpdated(this.task); 
}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks; 
  TaskLoaded(this.tasks); 
}

class TaskDeleted extends TaskState {}

class TaskError extends TaskState {
  final String message; 
  TaskError(this.message); 
}
