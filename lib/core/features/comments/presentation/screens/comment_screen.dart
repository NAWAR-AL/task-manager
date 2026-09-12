import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Expanded(
          //   child: BlocConsumer<TaskBloc, TaskState>(
          //     builder: (context, state) {
          //       if (state is TaskLoading) {
          //         return const Center(child: CircularProgressIndicator());
          //       }
          //       if (state is TaskLoaded) {
          //         final tasks = state.tasks;
          //         final newTasks = tasks
          //             .where((task) => task.status == "pending")
          //             .toList();
          //         final inProgressTasks = tasks
          //             .where((task) => task.status == "in_progress")
          //             .toList();
          //         final completedTasks = tasks
          //             .where((task) => task.status == "completed")
          //             .toList();
          //         final scheduleTasks = tasks
          //             .where((task) => task.status == "schedule")
          //             .toList();
          //         return TabBarView(
          //           children: [
          //             TaskList(tasks: newTasks),
          //             TaskList(tasks: inProgressTasks),
          //             TaskList(tasks: completedTasks),
          //             TaskList(tasks: scheduleTasks),
          //           ],
          //         );
          //       }
          //       return Center(child: Text("No Tasks Yet"));
          //     },
          //     listener: ((context, state) {
          //       if (state is TaskError) {
          //         ScaffoldMessenger(
          //           child: SnackBar(content: Text(state.message)),
          //         );
          //       }
          //     }),
          //   ),
          // ),
        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.lightBlue,
      //   onPressed: () {},
      //   child: Icon(Icons.add, color: Colors.white),
      // ),
      // bottomNavigationBar: TaskBottomBar(),
    );
  }
}
