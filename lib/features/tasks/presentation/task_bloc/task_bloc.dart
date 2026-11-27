import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/core/network/api_error.dart';
import 'package:task_manager/features/tasks/domain/entities/task_entity.dart';
import 'package:task_manager/features/tasks/domain/usercases/create_task_usecase.dart';
import 'package:task_manager/features/tasks/domain/usercases/delete_task_usecase.dart';
import 'package:task_manager/features/tasks/domain/usercases/get_tasks_usecase.dart';
import 'package:task_manager/features/tasks/domain/usercases/update_status_usecase.dart';
import 'package:task_manager/features/tasks/domain/usercases/update_task_usecase.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasksUsecase getTasksUsecase;
  final CreatetaskUsecase createtaskUsecase;
  final UpdatetaskUsecase updatetaskUsecase;
  final DeletetaskUsecase deletetaskUsecase;
  final UpdatestatusUsecase updatestatusUsecase;
  TaskBloc({
    required this.createtaskUsecase,
    required this.getTasksUsecase,
    required this.deletetaskUsecase,
    required this.updatetaskUsecase,
    required this.updatestatusUsecase,
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
      // emit(TaskLoading());
      try {
        await deletetaskUsecase(event.id);

        add(GetTasks());
      } catch (e) {
        emit(TaskError(readableApiError(e)));
      }
    });

    on<UpdateTaskEvent>((event, emit) async {
      try {
        // 1. تحديث البيانات العامة للمهمة
        await updatetaskUsecase(event.task);

        await updatestatusUsecase(event.task);

        emit(TaskUpdated(event.task));
        add(GetTasks()); // إعادة جلب المهام لتحديث القائمة فوراً
      } catch (e) {
        emit(TaskError(readableApiError(e)));
      }
    });
    on<UpdateTaskStatusEvent>((event, emit) async {
      try {
        await updatestatusUsecase(
          TaskEntity(
            id: event.id,
            title: '',
            description: 'description',
            project_id: 0,
            due_date: DateTime.now(),
            priority: '',
            status: event.status,
          ),
        );
        add(GetTasks());
      } catch (e) {
        emit(TaskError(readableApiError(e)));
      }
    });
  }
}
