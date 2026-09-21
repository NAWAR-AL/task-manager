import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:task_manager/core/di/injection_container.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/logout_cubit.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/logout_state.dart';
import 'package:task_manager/core/features/auth/presentation/pages/login_page.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/project_cubit.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/projects_state.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/create_project_page.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/project_details_page.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/projects_page.dart';
import 'package:task_manager/core/features/tasks/presentation/task_bloc/task_bloc.dart';

class DashScreen extends StatefulWidget {
  const DashScreen({super.key});

  @override
  State<DashScreen> createState() => _DashScreenState();
}

class _DashScreenState extends State<DashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(GetTasks());
    context.read<ProjectCubit>().fetchProjects();
  }

  Future<void> _openCreateProject() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<ProjectCubit>(),
          child: const CreateProjectPage(),
        ),
      ),
    );
    if (!mounted) return;
    context.read<ProjectCubit>().fetchProjects();
  }

  void _openProjectDetails(int? projectId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<ProjectCubit>(),
          child: ProjectDetailsPage(projectId: projectId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Logged out successfully"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My Projects",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProjectsPage(),
                        ),
                      );
                    },
                    child: const Text("View All"),
                  ),
                ],
              ),
              const Gap(10),
              BlocBuilder<ProjectCubit, ProjectsState>(
                builder: (context, state) {
                  if (state is ProjectsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ProjectsError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is ProjectsLoaded) {
                    final projects = state.projects;
                    if (projects.isEmpty) {
                      return Center(
                        child: TextButton(
                          onPressed: _openCreateProject,
                          child: const Text(
                            "No Projects yet, Create from here",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      );
                    }
                    return GridView.builder(
                      itemCount: projects.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 20,
                        mainAxisExtent: 200,
                      ),
                      itemBuilder: (context, index) {
                        final project = projects[index];
                        return Card(
                          elevation: 2,
                          borderOnForeground: true,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: ColorsApp.icons,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          shadowColor: Colors.blueGrey,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => _openProjectDetails(project.id),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: const BoxDecoration(
                                          color: Color(0xffdce7f9),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.folder_outlined,
                                          color: ColorsApp.icons,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          project.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.lightBlueAccent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(10),
                                  Text(
                                    project.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    project.createdAt?.timeZoneName ?? '',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const Gap(20),
              Card(
                child: BlocConsumer<TaskBloc, TaskState>(
                  builder: (BuildContext context, TaskState state) {
                    if (state is TaskLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is TaskLoaded) {
                      final tasks = state.tasks;
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const <DataColumn>[
                            DataColumn(label: Text("Task Name")),
                            DataColumn(label: Text("Project Name")),
                            DataColumn(label: Text("Priority")),
                            DataColumn(label: Text("Due Date")),
                            DataColumn(label: Text("Status")),
                          ],
                          rows: tasks.map((task) {
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(Text(task.title)),
                                DataCell(Text('${task.project_id}')),
                                DataCell(Text(task.priority)),
                                DataCell(
                                  Text(task.due_date.toString().split(' ').first),
                                ),
                                DataCell(Text(task.status)),
                              ],
                            );
                          }).toList(),
                        ),
                      );
                    }
                    return const Center(child: Text("No Tasks Yet"));
                  },
                  listener: (BuildContext context, TaskState state) {
                    if (state is TaskError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
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