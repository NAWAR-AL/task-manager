import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/tasks/presentation/task_bloc/task_bloc.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/task_list.dart';

class Task extends StatefulWidget {
  Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  int id = 0;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
                Tab(text: "New Task"),
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
                  final newTasks = tasks
                      .where((task) => task.status == "pending")
                      .toList();
                  final inProgressTasks = tasks
                      .where((task) => task.status == "in_progress")
                      .toList();
                  final completedTasks = tasks
                      .where((task) => task.status == "completed")
                      .toList();
                  final scheduleTasks = tasks
                      .where((task) => task.status == "schedule")
                      .toList();
                  return TabBarView(
                    children: [
                      TaskList(tasks: newTasks),
                      TaskList(tasks: inProgressTasks),
                      TaskList(tasks: completedTasks),
                      TaskList(tasks: scheduleTasks),
                    ],
                  );
                }
                return Center(child: Text("No Tasks Yet"));
              },
              listener: ((context, state) {
                if (state is TaskError) {
                  ScaffoldMessenger(
                    child: SnackBar(content: Text(state.message)),
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
