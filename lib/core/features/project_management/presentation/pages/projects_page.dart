import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_manager/core/di/injection_container.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/project_cubit.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/projects_state.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/create_project_page.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/project_details_page.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/update_project_page.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProjectCubit>().fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Projects List'), centerTitle: true),
      body: BlocConsumer<ProjectCubit, ProjectsState>(
        listener: (context, state) {
          if (state is ProjectError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ProjectLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProjectsLoaded) {
            final projectsList = state.projects;
            if (projectsList.isEmpty) {
              return const Center(child: Text('No available projects'));
            }
            return ListView.builder(
              itemCount: projectsList.length,
              itemBuilder: (context, index) {
                final project = projectsList[index];
                final color = ColorsApp
                    .projectColors[index % ColorsApp.projectColors.length];

                return Dismissible(
                  key: Key(project.id.toString()),
                  direction: DismissDirection.horizontal,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete Project'),
                              content: Text(
                                'Are you sure you want to delete the "${project.name}"؟',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        ) ??
                        false;
                  },
                  onDismissed: (direction) {
                    context.read<ProjectCubit>().deleteProject(project.id!);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Center(
                      child: SizedBox(
                        height: 90,
                        width: 350,
                        child: Card(
                          color: color,
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (_) => sl<ProjectCubit>(),
                                    child: ProjectDetailsPage(
                                      projectId: project.id,
                                    ),
                                  ),
                                ),
                              );
                            },
                            leading: const Icon(
                              Icons.folder_open_outlined,
                              color: Colors.lightBlue,
                            ),
                            title: Text(project.name),
                            subtitle: Text(project.description),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.lightBlue,
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                      create: (_) => sl<ProjectCubit>(),
                                      child: UpdateProjectPage(
                                        project: project,
                                      ),
                                    ),
                                  ),
                                );
                                if (!context.mounted) return;
                                context.read<ProjectCubit>().fetchProjects();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text("loading projects..."));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsApp.icons,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => sl<ProjectCubit>(),
                child: const CreateProjectPage(),
              ),
            ),
          );
          if (!context.mounted) return;
          context.read<ProjectCubit>().fetchProjects();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
