import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/features/app_widgets/app_widgets.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/comments/presentation/comment_bloc/comment_bloc.dart';

class CommentScreen extends StatefulWidget {
  final int taskId;
  const CommentScreen({super.key, required this.taskId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return DateFormat('dd MMM yyyy • hh:mm a').format(date);
  }

  @override
  void initState() {
    super.initState();
    context.read<CommentBloc>().add(GetCommentsEvent(widget.taskId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<CommentBloc, CommentState>(
        builder: (context, state) {
          if (state is CommentsLoading) {
            return const LoadingView();
          }

          if (state is CommentsLoaded) {
            final comments = state.comments;

            if (comments.isEmpty) {
              return const EmptyState(
                icon: Icons.forum_outlined,
                title: 'No comments yet',
                subtitle: 'Comments you add on the task will show up here.',
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const InitialsAvatar(name: 'Comment', radius: 16),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Comment #${comment.id ?? index + 1}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            _formatDate(comment.created_at),
                            style: const TextStyle(
                              fontSize: 11,
                              color: ColorsApp.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        comment.content,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: ColorsApp.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (_, _) => const SizedBox(height: 12),
            );
          }

          if (state is CommentError) {
            return EmptyState(
              icon: Icons.cloud_off_outlined,
              title: 'Could not load comments',
              subtitle: state.message,
            );
          }

          return const EmptyState(
            icon: Icons.forum_outlined,
            title: 'No comments yet',
          );
        },
      ),
    );
  }
}
