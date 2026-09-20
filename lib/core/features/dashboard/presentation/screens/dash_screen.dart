import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/di/injection_container.dart';
import 'package:task_manager/core/features/project_management/domain/usecases/create_project_usecases.dart';
import 'package:task_manager/core/features/project_management/domain/usecases/delete_projects_usecases.dart';
import 'package:task_manager/core/features/project_management/domain/usecases/get_project_usecases.dart';
import 'package:task_manager/core/features/project_management/domain/usecases/get_projectdetails_usecases.dart';
import 'package:task_manager/core/features/project_management/domain/usecases/get_projects_usecases.dart';
import 'package:task_manager/core/features/project_management/domain/usecases/update_project_usecases.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/project_cubit.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/projects_state.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/create_project_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectCubit(
        getProjectsUsecases: GetProjectsUsecases(repo: sl()),
        getProjectUsecases: GetProjectUsecases(repo: sl()),
        createProjectUsecases: CreateProjectUsecases(repo: sl()),
        updateProjectUsecases: UpdateProjectUsecases(repo: sl()),
        deleteProjectsUsecases: DeleteProjectsUsecases(repo: sl()),
        getProjectdetailsUsecases: GetProjectdetailsUsecases(repo: sl()),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Projects",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  TextButton(onPressed: () {}, child: Text("View All")),
                ],
              ),
              SizedBox(height: 10),
              BlocBuilder<ProjectCubit, ProjectsState>(
                builder: (context, state) {
                  if (state is ProjectsLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is ProjectsLoaded) {
                    final projects = state.projects;
                    if (projects.isEmpty) {
                      return Center(child: Text("No Avalible Projects"));
                    }
                    return GridView.builder(
                      itemCount: projects.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1,
                        mainAxisExtent: 200,
                      ),
                      itemBuilder: (context, index) {
                        final project = projects[index];
                        Card(
                          elevation: 2,
                          borderOnForeground: true,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.deepPurpleAccent,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadiusGeometry.circular(12),
                          ),

                          shadowColor: Colors.blueGrey,
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
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Color(0xffdce7f9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.folder_outlined,

                                        color: Colors.purpleAccent,
                                      ),
                                    ),
                                    Text(
                                      project.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.lightBlueAccent,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 10),
                                Text(
                                  project.description,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),

                                Text(
                                  project.createdAt!.timeZoneName,
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(height: 20),
                                LinearProgressIndicator(value: 0.6),
                              ],
                            ),
                          ),
                        );
                        return null;
                      },
                    );
                  }
                  return Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreateProjectPage(),
                          ),
                        );
                      },
                      child: Text(
                        "No Projects yet, Create from here",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Card(
                child: BlocConsumer<TaskBloc, TaskState>(
                  builder: (BuildContext context, TaskState state) {
                    if (state is TaskLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is TaskLoaded) {
                      final task = state.tasks;
                      return DataTable(
                        columns: <DataColumn>[
                          ///1
                          DataColumn(label: Expanded(child: Text("Task Name"))),
                          //2
                          DataColumn(
                            label: Expanded(child: Text("Project Name")),
                          ),
                          //3
                          DataColumn(label: Expanded(child: Text("Priority"))),
                          //4
                          DataColumn(label: Expanded(child: Text("Due Date"))),
                          //5
                          DataColumn(label: Expanded(child: Text("Status"))),
                        ],
                        rows: task.map((task) {
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(Text(task.title)),
                              DataCell(Text("Task ${task.project_id}")),
                              DataCell(Text("Task ${task.priority}")),
                              DataCell(Text("Task ${task.due_date}")),
                              DataCell(Text("Task ${task.status}")),
                            ],
                          );
                        }).toList(),
                      );
                    }
                    return Center(child: Text("No Tasks Yet"));
                  },
                  listener: (BuildContext context, TaskState state) {
                    if (state is TaskError) {
                      ScaffoldMessenger(
                        child: SnackBar(content: Text(state.message)),
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
