import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_cubit.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_state.dart';
import 'package:task_manager/core/features/comments/domain/entities/comment_entity.dart';
import 'package:task_manager/core/features/comments/presentation/comment_bloc/comment_bloc.dart';
import 'package:task_manager/core/features/comments/presentation/screens/comment_screen.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/project_cubit.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/projects_state.dart';
import 'package:task_manager/core/features/tasks/domain/entities/task_entity.dart';
import 'package:task_manager/core/features/tasks/presentation/screens/update_task.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/details_widget.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/task_field.dart';

class TaskDetails extends StatefulWidget {
  final TaskEntity task;
  const TaskDetails({super.key, required this.task});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  final commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProjectCubit>().fetchProjects();
    context.read<ProfileCubit>().getUsers();
    context.read<CommentBloc>().add(GetCommentsEvent(widget.task.id!));
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd MM yyyy hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.task.title,
          style: const TextStyle(color: Color(0xffB1E5E6)),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UpdateTaskPage(updatedTask: widget.task),
                ),
              );
            },
            icon: const Icon(Icons.edit_outlined),
            color: const Color(0xffF7ADAD),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Task Details',
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
            ),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildDetailRow(
                      icon: Icons.description_outlined,
                      title: 'Description: ',
                      value: widget.task.description.isEmpty
                          ? 'No description provided'
                          : widget.task.description,
                    ),
                    buildDetailRow(
                      icon: Icons.priority_high_outlined,
                      title: 'Priority: ',
                      value: widget.task.priority.isEmpty
                          ? 'Low'
                          : widget.task.priority,
                    ),
                    buildDetailRow(
                      icon: Icons.calendar_month_outlined,
                      title: 'Due Date:',
                      value: _formatDate(widget.task.due_date),
                    ),
                    BlocBuilder<ProjectCubit, ProjectsState>(
                      builder: (context, state) {
                        String projectName = 'project ${widget.task.project_id}';
                        if (state is ProjectsLoaded) {
                          final matches = state.projects
                              .where((p) => p.id == widget.task.project_id)
                              .toList();
                          if (matches.isNotEmpty) {
                            projectName = matches.first.name;
                          }
                        }
                        return buildDetailRow(
                          icon: Icons.task_alt_outlined,
                          title: 'Project: ',
                          value: projectName,
                        );
                      },
                    ),
                    buildDetailRow(
                      icon: Icons.task_alt_outlined,
                      title: 'Task Status: ',
                      value: widget.task.status,
                    ),
                    buildDetailRow(
                      icon: Icons.person_outline,
                      title: 'Created By',
                      value: widget.task.created_by?.toString() ?? 'N/A',
                    ),
                    buildDetailRow(
                      icon: Icons.create_rounded,
                      title: 'Created At:',
                      value: _formatDate(widget.task.created_at),
                    ),
                    buildDetailRow(
                      icon: Icons.update_sharp,
                      title: 'Updated At:',
                      value: _formatDate(widget.task.updated_at),
                    ),
                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        if (widget.task.assigned_users == null ||
                            widget.task.assigned_users!.isEmpty) {
                          return buildDetailRow(
                            icon: Icons.person_outline,
                            title: 'Assigned Developers: ',
                            value: 'No Developers assigned',
                          );
                        }

                        String developersText = widget.task.assigned_users!
                            .map((devId) {
                              String developerName = 'Developer $devId';
                              if (state is UsersLoaded) {
                                final matches =
                                    state.users.where((u) => u.id == devId).toList();
                                if (matches.isNotEmpty) {
                                  developerName = matches.first.name;
                                }
                              }
                              return developerName;
                            })
                            .join(', ');

                        return buildDetailRow(
                          icon: Icons.person_outline,
                          title: 'Assigned Developers: ',
                          value: developersText,
                        );
                      },
                    ),
                    const Divider(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CommentScreen(taskId: widget.task.id!),
                          ),
                        );
                      },
                      child: const Text('More comments'),
                    ),
                    TaskField(
                      fieldController: commentController,
                      fieldLabel: 'Add Comment',
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffB1E5E6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (commentController.text.trim().isNotEmpty) {
                          final commentEntity = CommentEntity(
                            content: commentController.text,
                          );
                          context.read<CommentBloc>().add(
                            CreateCommentEvent(widget.task.id!, commentEntity),
                          );
                          commentController.clear();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: BlocProvider.of<CommentBloc>(context),
                                child: CommentScreen(taskId: widget.task.id!),
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Add Comment'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}