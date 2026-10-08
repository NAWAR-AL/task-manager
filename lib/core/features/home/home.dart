import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/app_widgets/drawer.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/project_cubit.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/projects_state.dart';
import 'package:task_manager/core/features/tasks/presentation/screens/create_task.dart';
import 'package:task_manager/core/features/tasks/presentation/task_bloc/task_bloc.dart';
import 'package:task_manager/core/permission/role.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    context.read<TaskBloc>().add(GetTasks());
    context.read<ProjectCubit>().fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    int rowItems = 7;
    final List<DateTime> monthDays = List.generate(
      30,
      (index) => DateTime.now().add(Duration(days: index)),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          const CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
      drawer: DrawerHome(role: UserRole.admin),
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/desgin.png'),
              const Text(
                'Welcome to Orbit Task Management App ',
                softWrap: true,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('EEEE, MMMM d, yyyy').format(selectedDate),
                style: TextStyle(fontSize: 14, color: ColorsApp.background3),
              ),
              const SizedBox(height: 30),

              SizedBox(
                height: 80,
                child: ListView.builder(
                  // itemExtent: 7,
                  scrollDirection: Axis.horizontal,
                  itemCount: (monthDays.length / rowItems).ceil(),
                  itemBuilder: (context, index) {
                    final day = monthDays[index];
                    final isSelected =
                        day.year == selectedDate.year &&
                        day.month == selectedDate.month &&
                        day.day == selectedDate.day;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = day;
                        });
                      },
                      child: Container(
                        width: 60,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ColorsApp.background1
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            if (!isSelected)
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                blurRadius: 5,
                                spreadRadius: 2,
                              ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('E').format(day),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white70
                                    : Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              day.day.toString(),
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: BlocBuilder<ProjectCubit, ProjectsState>(
                  builder: (context, state) {
                    if (state is ProjectLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is ProjectsLoaded) {
                      final filteredProjects = state.projects.where((project) {
                        try {
                          final createdAt = DateTime.parse(
                            project.createdAt.toString(),
                          );
                          return createdAt.year == selectedDate.year &&
                              createdAt.month == selectedDate.month &&
                              createdAt.day == selectedDate.day;
                        } catch (e) {
                          return false;
                        }
                      }).toList();

                      if (filteredProjects.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_available,
                                size: 50,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CreatetaskPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "No  projects for this day, Add now ",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredProjects.length,
                        itemBuilder: (context, index) {
                          final project = filteredProjects[index];

                          final bool isEven = index % 2 == 0;
                          final cardColor = isEven
                              ? ColorsApp.background2
                              : ColorsApp.background3;

                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Project Name: ${project.name}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Status: ${project.status} ',
                                          style: const TextStyle(
                                            color: Colors.black26,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white54,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return const Center(
                      child: Text("Please check your internet connection"),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    if (state is TaskLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is TaskLoaded) {
                      final filteredTasks = state.tasks.where((task) {
                        try {
                          final dueDate = DateTime.parse(
                            task.due_date.toString(),
                          );
                          return dueDate.year == selectedDate.year &&
                              dueDate.month == selectedDate.month &&
                              dueDate.day == selectedDate.day;
                        } catch (e) {
                          return false;
                        }
                      }).toList();

                      if (filteredTasks.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_available,
                                size: 50,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CreatetaskPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "No tasks for this day, Add now ",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];

                          final bool isEven = index % 2 == 0;
                          final cardColor = isEven
                              ? ColorsApp.background2
                              : ColorsApp.background3;

                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Task Title: ${task.title}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Status: ${task.status} | Priority: ${task.priority}',
                                          style: const TextStyle(
                                            color: Colors.black26,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white54,
                                      size: 16,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => CreatetaskPage(),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.add_task,
                                        color: ColorsApp.background3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return const Center(
                      child: Text("Please check your internet connection"),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
