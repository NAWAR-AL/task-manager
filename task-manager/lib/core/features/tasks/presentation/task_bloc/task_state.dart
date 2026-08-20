part of 'task_bloc.dart';

@immutable
abstract class TaskState {}

class TaskInitial extends TaskState {}

class Taskcreate extends TaskState {}

class Taskupdate extends TaskState {}

class TaskgetTasks extends TaskState {}

class TaskgetTask extends TaskState {}

class Taskdelete extends TaskState {}

class TaskupdateStatus extends TaskState {}
