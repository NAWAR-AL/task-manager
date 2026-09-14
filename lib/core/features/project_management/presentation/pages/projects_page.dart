import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/project_management/domain/entities/project.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/project_cubit.dart';
import '../cubit/project_cubit.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/projects_state.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/create_project_page.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/project_details_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects List'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CreateProjectPage()),
              );
            },
            icon: const Icon(Icons.add, color: Colors.lightBlue),
          ),
        ],
      ),
      body: BlocConsumer<ProjectCubit, ProjectsState>(
        listener: (context, state) {
          if (state is ProjectError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
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

                return Dismissible(
                  key: Key(project.id.toString()),
                  direction: DismissDirection.horizontal,
                  
                  // الخلفية عند السحب جهة اليمين
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  
                  // الخلفية عند السحب جهة اليسار
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),

                  // نافذة تأكيد الحذف
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('تأكيد الحذف'),
                          content: Text('هل أنت تأكد من إزالة مشروع "${project.name}"؟'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('إلغاء'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('حذف'),
                            ),
                          ],
                        );
                      },
                    ) ?? false;
                  },

                  // تنفيذ الحذف عبر الكيوبيت بعد موافقة المستخدم
                  onDismissed: (direction) {
                    context.read<ProjectCubit>().deleteProject(project.id!);
                  },

                  child: Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProjectDetailsPage(projectId: project.id),
                          ),
                        );
                      },
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
                              builder: (context) => UpdateProjectPage(project: projectEntity),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit, color: Colors.lightBlue),
                      ),
                      leading: const Icon(
                        Icons.folder_open_outlined,
                        color: Colors.lightBlue,
                      ),
                      subtitle: Text(project.description),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text("loading projects."));
        },
      ),
    );
  }
}