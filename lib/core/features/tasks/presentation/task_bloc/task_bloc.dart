import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/core/network/api_error.dart';
import 'package:task_manager/core/features/tasks/domain/entities/task_entity.dart';
import 'package:task_manager/core/features/tasks/domain/usercases/create_task_usecase.dart';
import 'package:task_manager/core/features/tasks/domain/usercases/deleteTask_usecase.dart';
import 'package:task_manager/core/features/tasks/domain/usercases/getTasks_usecase.dart';
import 'package:task_manager/core/features/tasks/domain/usercases/updateTask_usecase.dart';

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
        emit(TaskError(readableApiError(e)));
      }
    });
    on<CreateTaskEvent>((event, emit) async {
      emit(TaskLoading());
      try {
        final task = await createtaskUsecase(event.task);
        emit(TaskCreated(task));
      } catch (e) {
        emit(TaskError(readableApiError(e)));
      }
    });
    on<DeleteTaskEvent>((event, emit) async {
      print('delete task event for is ${event.id}');
      // emit(TaskLoading());
      try {
        await deletetaskUsecase(event.id);
        // print('Task deleted from server');
        add(GetTasks());
        // emit(TaskDeleted());
      } catch (e) {
        print('erroe in delete bloc :$e');
        emit(TaskError(readableApiError(e)));
      }
    });
    on<UpdateTaskEvent>((event, emit) async {
      emit(TaskLoading());
      try {
        final task = await updatetaskUsecase(event.task);
        emit(TaskUpdated(task));
      } catch (e) {
        emit(TaskError(readableApiError(e)));
      }
    });
  }
}
