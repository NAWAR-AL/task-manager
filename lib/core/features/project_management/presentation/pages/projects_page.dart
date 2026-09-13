import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/project_management/domain/entities/project.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/project_cubit.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/projects_state.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/create_project_page.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/update_project_page.dart';

class ProjectsPage extends StatefulWidget {
  ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProjectCubit>().fetchProjects();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects List'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CreateProjectPage()),
              );
            },
            icon: Icon(Icons.add, color: Colors.lightBlue),
          ),
        ],
      ),
      body: BlocBuilder<ProjectCubit, ProjectsState>(
        builder: ((context, state) {
          if (state is ProjectLoading) {
            return CircularProgressIndicator();
          }
          if (state is ProjectsLoaded) {
            final projectsList = state.projects;
            if (projectsList.isEmpty) {
              return Center(child: Text('No avalible projects'));
            }
            return ListView.builder(
              itemCount: projectsList.length,
              itemBuilder: (context, index) {
                final project = projectsList[index];
                return Card(
                  child: ListTile(
                    title: Text(project.name),
                    trailing: IconButton(
                      onPressed: () {
                        final projectEntity = ProjectEntity(
                          name: project.name,
                          description: project.description,
                          status: project.status,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UpdateProjectPage(project: projectEntity),
                          ),
                        );
                        print('object');
                      },
                      icon: Icon(Icons.edit, color: Colors.lightBlue),
                    ),
                    leading: Icon(
                      Icons.folder_open_outlined,
                      color: Colors.lightBlue,
                    ),
                    subtitle: Text(project.description),
                  ),
                );
              },
            );
          }
          if (state is ProjectError) {
            return Center(child: Text('please read the error $state.message'));
          }
          return const Center(child: Text("loading projects."));
        }),
      ),
    );
  }
}
