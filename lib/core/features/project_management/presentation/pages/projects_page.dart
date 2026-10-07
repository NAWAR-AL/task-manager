import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/di/injection_container.dart';
import 'package:task_manager/core/features/app_widgets/app_widgets.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/app_widgets/drawer.dart';
import 'package:task_manager/core/features/project_management/domain/entities/project.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/project_cubit.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/projects_state.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/create_project_page.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/project_details_page.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/update_project_page.dart';
import 'package:task_manager/core/permission/role.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  // آخر قائمة تم تحميلها حتى ما تظل القائمة عاللودينق عند أي حالة
  List<ProjectEntity>? _cachedProjects;

  @override
  void initState() {
    super.initState();
    context.read<ProjectCubit>().fetchProjects();
  }

  Future<void> _openDetails(ProjectEntity project) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<ProjectCubit>(),
          child: ProjectDetailsPage(projectId: project.id),
        ),
      ),
    );
    if (!mounted) return;
    context.read<ProjectCubit>().fetchProjects();
  }

  Future<void> _openEdit(ProjectEntity project) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<ProjectCubit>(),
          child: UpdateProjectPage(project: project),
        ),
      ),
    );
    if (!mounted) return;
    context.read<ProjectCubit>().fetchProjects();
  }

  Future<void> _openCreate() async {
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

  Future<bool> _confirmDelete(ProjectEntity project) async {
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Delete project'),
            content: Text(
              'Are you sure you want to delete "${project.name}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                style: TextButton.styleFrom(foregroundColor: ColorsApp.danger),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget _buildProjectCard(ProjectEntity project) {
    return Dismissible(
      key: Key('project_${project.id}'),
      direction: DismissDirection.horizontal,
      background: _deleteBackground(Alignment.centerLeft),
      secondaryBackground: _deleteBackground(Alignment.centerRight),
      confirmDismiss: (_) => _confirmDelete(project),
      onDismissed: (_) {
        context.read<ProjectCubit>().deleteProject(project.id!);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('"${project.name}" deleted'),
              backgroundColor: ColorsApp.danger,
            ),
          );
      },
      child: AppCard(
        onTap: () => _openDetails(project),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: ColorsApp.primarySoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.folder_copy_outlined,
                color: ColorsApp.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: ColorsApp.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    project.description.trim().isEmpty
                        ? 'No description'
                        : project.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: ColorsApp.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  StatusChip(status: project.status),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Edit project',
              onPressed: () => _openEdit(project),
              icon: const Icon(Icons.edit_outlined),
              style: IconButton.styleFrom(
                backgroundColor: ColorsApp.primarySoft,
                foregroundColor: ColorsApp.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deleteBackground(Alignment alignment) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: ColorsApp.danger,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: const Icon(Icons.delete_outline, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      drawer: const DrawerHome(role: UserRole.admin),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreate,
        tooltip: 'New Project',
        icon: const Icon(Icons.add_business, color: Colors.white),
        label: const Text(
          'New Project',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocConsumer<ProjectCubit, ProjectsState>(
        listener: (context, state) {
          if (state is ProjectsLoaded) {
            _cachedProjects = state.projects;
          }
          if (state is ProjectError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        builder: (context, state) {
          final projects = _cachedProjects;

          if (projects == null) {
            if (state is ProjectError) {
              return EmptyState(
                icon: Icons.cloud_off_outlined,
                title: 'Could not load projects',
                subtitle: state.message,
              );
            }
            return const LoadingView();
          }

          if (projects.isEmpty) {
            return const EmptyState(
              icon: Icons.folder_open_outlined,
              title: 'No projects yet',
              subtitle: 'Tap "New Project" to create your first project.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            itemCount: projects.length,
            itemBuilder: (context, index) =>
                _buildProjectCard(projects[index]),
            separatorBuilder: (_, _) => const SizedBox(height: 12),
          );
        },
      ),
    );
  }
}
