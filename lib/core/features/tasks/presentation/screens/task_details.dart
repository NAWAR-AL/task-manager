import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/features/app_widgets/app_widgets.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_cubit.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_state.dart';
import 'package:task_manager/core/features/comments/domain/entities/comment_entity.dart';
import 'package:task_manager/core/features/comments/presentation/comment_bloc/comment_bloc.dart';
import 'package:task_manager/core/features/comments/presentation/screens/comment_screen.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/project_cubit.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/projects_state.dart';
import 'package:task_manager/core/features/tasks/domain/entities/task_entity.dart';
import 'package:task_manager/core/features/tasks/presentation/screens/update_task.dart';

class TaskDetails extends StatefulWidget {
  final TaskEntity task;
  const TaskDetails({super.key, required this.task});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  final commentController = TextEditingController();
  bool _isAddingComment = false;

  @override
  void initState() {
    super.initState();
    context.read<ProjectCubit>().fetchProjects();
    context.read<ProfileCubit>().getUsers();
    context.read<CommentBloc>().add(GetCommentsEvent(widget.task.id!));
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return DateFormat('dd MMM yyyy • hh:mm a').format(date);
  }

  void _addComment() {
    final content = commentController.text.trim();
    if (content.isEmpty) return;

    setState(() => _isAddingComment = true);
    context.read<CommentBloc>().add(
      CreateCommentEvent(widget.task.id!, CommentEntity(content: content)),
    );
  }

  String _projectName(BuildContext context) {
    final state = context.watch<ProjectCubit>().state;
    if (state is ProjectsLoaded) {
      final matches = state.projects
          .where((p) => p.id == widget.task.project_id)
          .toList();
      if (matches.isNotEmpty) return matches.first.name;
    }
    return 'Project ${widget.task.project_id}';
  }

  String _developersText(BuildContext context) {
    final ids = widget.task.assigned_users;
    if (ids == null || ids.isEmpty) return 'No developers assigned';

    final state = context.watch<ProfileCubit>().state;
    return ids.map((devId) {
      if (state is UsersLoaded) {
        final matches = state.users.where((u) => u.id == devId).toList();
        if (matches.isNotEmpty) return matches.first.name;
      }
      return 'Developer $devId';
    }).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return BlocListener<CommentBloc, CommentState>(
      listener: (context, state) {
        if (state is CommentsAdded) {
          commentController.clear();
          setState(() => _isAddingComment = false);
        }
        if (state is CommentError) {
          setState(() => _isAddingComment = false);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            task.title,
            overflow: TextOverflow.ellipsis,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              tooltip: 'Edit task',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UpdateTaskPage(updatedTask: task),
                  ),
                );
              },
              icon: const Icon(Icons.edit_outlined),
            ),
            const SizedBox(width: 6),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          children: [
            // الهيدر
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                          Icons.task_alt_outlined,
                          color: ColorsApp.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: ColorsApp.textPrimary,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (task.description.trim().isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Text(
                      task.description,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: ColorsApp.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      StatusChip(status: task.status),
                      PriorityChip(priority: task.priority),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // التفاصيل
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppSectionTitle(
                    text: 'Details',
                    icon: Icons.info_outline,
                  ),
                  const SizedBox(height: 6),
                  DetailRow(
                    icon: Icons.folder_outlined,
                    label: 'Project',
                    value: _projectName(context),
                  ),
                  const Divider(),
                  DetailRow(
                    icon: Icons.event_outlined,
                    label: 'Due date',
                    value: _formatDate(task.due_date),
                  ),
                  const Divider(),
                  DetailRow(
                    icon: Icons.group_outlined,
                    label: 'Assigned developers',
                    value: _developersText(context),
                  ),
                  const Divider(),
                  DetailRow(
                    icon: Icons.person_outline,
                    label: 'Created by (ID)',
                    value: task.created_by?.toString() ?? '—',
                  ),
                  const Divider(),
                  DetailRow(
                    icon: Icons.calendar_month_outlined,
                    label: 'Created at',
                    value: _formatDate(task.created_at),
                  ),
                  const Divider(),
                  DetailRow(
                    icon: Icons.update_rounded,
                    label: 'Last updated',
                    value: _formatDate(task.updated_at),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // التعليقات
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSectionTitle(
                    text: 'Comments',
                    icon: Icons.chat_bubble_outline,
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<CommentBloc, CommentState>(
                    builder: (context, state) {
                      if (state is CommentsLoading) {
                        return const LinearProgressIndicator(minHeight: 2);
                      }
                      if (state is CommentsLoaded) {
                        final comments = state.comments;
                        if (comments.isEmpty) {
                          return const Text(
                            'No comments yet — be the first.',
                            style: TextStyle(
                              fontSize: 13,
                              color: ColorsApp.textSecondary,
                            ),
                          );
                        }
                        final preview = comments.take(2).toList();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...preview.map(
                              (comment) => Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: ColorsApp.background,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.field,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment.content,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatDate(comment.created_at),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: ColorsApp.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (comments.length > 2)
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CommentScreen(taskId: task.id!),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.forum_outlined, size: 18),
                                label: Text(
                                  'View all ${comments.length} comments',
                                ),
                              ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 8),
                  AppTextField(
                    controller: commentController,
                    label: 'Add a comment',
                    hint: 'Write something…',
                    prefixIcon: Icons.edit_note_outlined,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Add Comment',
                    icon: Icons.send_rounded,
                    loading: _isAddingComment,
                    onPressed: _addComment,
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CommentScreen(taskId: task.id!),
                        ),
                      );
                    },
                    icon: const Icon(Icons.forum_outlined, size: 18),
                    label: const Text('Open comments page'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}