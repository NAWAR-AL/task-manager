import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/features/app_widgets/app_widgets.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/project_management/domain/entities/project.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/project_cubit.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/projects_state.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/update_project_page.dart';

class ProjectDetailsPage extends StatefulWidget {
  final int? projectId;
  const ProjectDetailsPage({super.key, required this.projectId});

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return DateFormat('dd MMM yyyy • hh:mm a').format(date);
  }

  @override
  void initState() {
    super.initState();
    context.read<ProjectCubit>().getProjectDetails(widget.projectId!);
  }

  Widget _buildHeader(ProjectEntity project) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: ColorsApp.primarySoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.folder_copy_outlined,
                  color: ColorsApp.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: ColorsApp.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    StatusChip(status: project.status),
                  ],
                ),
              ),
            ],
          ),
          if (project.description.trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              project.description,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: ColorsApp.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfo(ProjectEntity project) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionTitle(text: 'Information', icon: Icons.info_outline),
          const SizedBox(height: 6),
          DetailRow(
            icon: Icons.flag_outlined,
            label: 'Status',
            value: ColorsApp.prettyStatus(project.status),
          ),
          const Divider(),
          DetailRow(
            icon: Icons.tag,
            label: 'Project ID',
            value: project.id?.toString() ?? '—',
          ),
          const Divider(),
          DetailRow(
            icon: Icons.person_outline,
            label: 'Created by (ID)',
            value: project.createdBy?.toString() ?? '—',
          ),
          const Divider(),
          DetailRow(
            icon: Icons.calendar_month_outlined,
            label: 'Created at',
            value: _formatDate(project.createdAt),
          ),
          const Divider(),
          DetailRow(
            icon: Icons.update_rounded,
            label: 'Last updated',
            value: _formatDate(project.updatedAt),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ProjectCubit, ProjectsState>(
        builder: (context, state) {
          if (state is ProjectLoading) {
            return const LoadingView();
          }
          if (state is GetProjectDetailesLoaded) {
            final project = state.project;
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              children: [
                _buildHeader(project),
                const SizedBox(height: 16),
                _buildInfo(project),
                const SizedBox(height: 24),
                AppButton(
                  label: 'Edit Project',
                  icon: Icons.edit_outlined,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UpdateProjectPage(project: project),
                      ),
                    );
                  },
                ),
              ],
            );
          }
          if (state is ProjectError) {
            return EmptyState(
              icon: Icons.cloud_off_outlined,
              title: 'Could not load the project',
              subtitle: state.message,
            );
          }
          return const EmptyState(
            icon: Icons.folder_open_outlined,
            title: 'No project selected',
          );
        },
      ),
    );
  }
}