import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskmanger/core/features/tasks/domain/entities/task_entity.dart';
import 'package:taskmanger/core/features/tasks/domain/usercases/createTask_usecase.dart';
import 'package:taskmanger/core/features/tasks/domain/usercases/deleteTask_usecase.dart';
import 'package:taskmanger/core/features/tasks/domain/usercases/getTasks_usecase.dart';
import 'package:taskmanger/core/features/tasks/domain/usercases/updateTask_usecase.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasksUsecase getTasksUsecase;
  final CreatetaskUsecase createtaskUsecase;
  final UpdatetaskUsecase updatetaskUsecase;
  final DeletetaskUsecase deletetaskUsecase;
  TaskBloc({
    required this.createtaskUsecase,
    required this.getTasksUsecase,
    required this.deletetaskUsecase,
    required this.updatetaskUsecase,
  }) : super(TaskInitial()) {
    on<GetTasks>((event, emit) async {
      emit(TaskLoading());
      try {
        final tasks = await getTasksUsecase();
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });
    on<CreateTask>((event, emit) async {
      emit(TaskLoading());
      try {
        final task = await createtaskUsecase(event.task);
        emit(TaskCreated(task));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });
    on<DeleteTask>((event, emit) async {
      emit(TaskLoading());
      try {
        await deletetaskUsecase(event.id);
        emit(TaskDeleted());
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });
    on<UpdateTask>((event, emit) async {
      emit(TaskLoading());
      try {
        final task = await updatetaskUsecase(event.task);
        emit(TaskUpdated(task));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });
  }
}
