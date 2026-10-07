import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/app_widgets/app_widgets.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/tasks/domain/entities/task_entity.dart';
import 'package:task_manager/core/features/tasks/presentation/screens/create_task.dart';
import 'package:task_manager/core/features/tasks/presentation/task_bloc/task_bloc.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/task_list.dart';

class TaskPage extends StatefulWidget {
  TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(GetTasks());
  }

  Future<void> _openCreateTask() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreatetaskPage()),
    );
    if (!mounted) return;
    // نحدّث القائمة بعد ما يرجع المستخدم من صفحة الإنشاء
    context.read<TaskBloc>().add(GetTasks());
  }

  Widget _tabWithCount(String label, int count) {
    return Tab(
      height: 52,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: ColorsApp.primarySoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: ColorsApp.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        builder: (context, state) {
          final tasks = state is TaskLoaded ? state.tasks : <TaskEntity>[];

          final inProgressTasks = tasks
              .where((task) => task.status == "in_progress")
              .toList();
          final completedTasks = tasks
              .where((task) => task.status == "done")
              .toList();
          final reviewTasks = tasks
              .where((task) => task.status == "review")
              .toList();

          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                // الهيدر
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tasks',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: ColorsApp.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${tasks.length} task${tasks.length == 1 ? '' : 's'} in total',
                              style: const TextStyle(
                                fontSize: 13,
                                color: ColorsApp.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 42),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          side: const BorderSide(color: ColorsApp.primary),
                        ),
                        onPressed: _openCreateTask,
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('New'),
                      ),
                    ],
                  ),
                ),

                // التابات
                Container(
                  decoration: const BoxDecoration(
                    color: ColorsApp.surface,
                    border: Border(
                      bottom: BorderSide(color: ColorsApp.divider),
                    ),
                  ),
                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    dividerColor: Colors.transparent,
                    tabs: [
                      _tabWithCount('In Progress', inProgressTasks.length),
                      _tabWithCount('Completed', completedTasks.length),
                      _tabWithCount('Review', reviewTasks.length),
                    ],
                  ),
                ),

                // المحتوى
                Expanded(
                  child: state is TaskLoading
                      ? const LoadingView()
                      : state is TaskError
                          ? EmptyState(
                              icon: Icons.cloud_off_outlined,
                              title: 'Could not load tasks',
                              subtitle: state.message,
                            )
                          : TabBarView(
                              children: [
                                TaskList(tasks: inProgressTasks),
                                TaskList(tasks: completedTasks),
                                TaskList(tasks: reviewTasks),
                              ],
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}