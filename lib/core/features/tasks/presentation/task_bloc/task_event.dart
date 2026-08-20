part of 'task_bloc.dart';

@immutable
abstract class TaskEvent {}
class getTasks extends TaskEvent{}
class createTask extends TaskEvent{}
class updateTask extends TaskEvent{}
class getoneTask extends TaskEvent{}
class deleteTask extends TaskEvent{}