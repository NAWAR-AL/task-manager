import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/tasks/presentation/task_bloc/task_bloc.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/task_list.dart';

class TaskPage extends StatefulWidget {
  TaskPage({super.key});

  // const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(GetTasks());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              indicatorPadding: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              labelPadding: EdgeInsets.symmetric(horizontal: 10),
              labelColor: Colors.lightBlue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.lightBlue,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: [
                // Tab(text: "New Task"),
                Tab(text: "In Progress"),
                Tab(text: "Completed"),
                Tab(text: "Scheduled"),
              ],
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: BlocConsumer<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is TaskLoaded) {
                  final tasks = state.tasks;
                  // final newTasks = tasks
                  //     .where((task) => task.status == "todo")
                  //     .toList();
                  final inProgressTasks = tasks
                      .where((task) => task.status == "in_progress")
                      .toList();
                  final completedTasks = tasks
                      .where((task) => task.status == "done")
                      .toList();
                  final scheduleTasks = tasks
                      .where((task) => task.status == "review")
                      .toList();
                  return TabBarView(
                    children: [
                      // buildNewTasksTab(context, tasks, 2),
                      // TaskList(tasks: newTasks),
                      TaskList(tasks: inProgressTasks),
                      TaskList(tasks: completedTasks),
                      TaskList(tasks: scheduleTasks),
                    ],
                  );
                }
                return Center(
                  child: Text("Please check Your Internet conection"),
                );
              },
              listener: (context, state) {
                if (state is TaskError) {
                  print('error of the ui is ${state.message}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'We Can not delete the task now,Please try again',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
