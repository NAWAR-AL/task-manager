import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/tasks/presentation/task_bloc/task_bloc.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/drawer.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/task_list.dart';
import 'package:task_manager/core/permission/role.dart';

class TaskScreen extends StatefulWidget {
  TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  int id = 0;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        // drawer: Drawer(child: ListView(children: [
        //   UserAccountsDrawerHeader(accountName: Text("data"), accountEmail: Text("data")),

        // ],)),
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: "New Task"),
              Tab(text: "In Progress"),
              Tab(text: "Schedule"),
              Tab(text: "Completed"),
            ],
          ),
          centerTitle: true,

          title: Text(
            "My Activity",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        drawer: DrawerHome(role: UserRole.editor),
        body: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlue,
          onPressed: () {},
          child: Icon(Icons.add, color: Colors.white),
        ),
        // bottomNavigationBar: TaskBottomBar(),
      ),
    );
  }
}
