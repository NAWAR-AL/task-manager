import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/features/app_widgets/app_widgets.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/tasks/domain/entities/task_entity.dart';
import 'package:task_manager/core/features/tasks/presentation/screens/task_details.dart';
import 'package:task_manager/core/features/tasks/presentation/task_bloc/task_bloc.dart';

class TaskList extends StatelessWidget {
  final List<TaskEntity> tasks;
  final String emptyTitle;
  final String emptySubtitle;

  const TaskList({
    super.key,
    required this.tasks,
    this.emptyTitle = 'No tasks here',
    this.emptySubtitle = 'Tasks with this status will appear here.',
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return EmptyState(icon: Icons.inbox_outlined, title: emptyTitle, subtitle: emptySubtitle);
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 100),
      itemCount: tasks.length,
      itemBuilder: (context, index) => _buildDismissible(context, tasks[index]),
      separatorBuilder: (_, _) => const SizedBox(height: 12),
    );
  }

  Widget _buildDismissible(BuildContext context, TaskEntity task) {
    return Dismissible(
      key: Key(task.id.toString()),
      direction: DismissDirection.horizontal,
      background: _deleteBackground(Alignment.centerLeft),
      secondaryBackground: _deleteBackground(Alignment.centerRight),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: const Text('Delete task'),
                content: Text(
                  'Are you sure you want to delete "${task.title}"?',
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
      },
      onDismissed: (_) {
        context.read<TaskBloc>().add(DeleteTaskEvent(task.id!));
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('"${task.title}" deleted'),
              backgroundColor: ColorsApp.danger,
            ),
          );
      },
      child: _TaskCard(task: task),
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
}

class _TaskCard extends StatelessWidget {
  final TaskEntity task;
  const _TaskCard({required this.task});

  bool get _isOverdue {
    return task.due_date.isBefore(DateTime.now()) && task.status != 'done';
  }

  @override
  Widget build(BuildContext context) {
    final priorityColor = ColorsApp.priorityColor(task.priority);

    return AppCard(
      padding: EdgeInsets.zero,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TaskDetails(task: task)),
        );
      },
      child: IntrinsicHeight(
        child: Row(
          children: [
            // شريط لون الأولوية
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(AppRadius.card),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: ColorsApp.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        StatusChip(status: task.status),
                        PriorityChip(priority: task.priority),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          _isOverdue
                              ? Icons.warning_amber_rounded
                              : Icons.event_outlined,
                          size: 15,
                          color: _isOverdue ? ColorsApp.danger : ColorsApp.textMuted,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Due ${DateFormat('dd MMM yyyy').format(task.due_date)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: _isOverdue ? FontWeight.w700 : FontWeight.w500,
                            color: _isOverdue
                                ? ColorsApp.danger
                                : ColorsApp.textSecondary,
                          ),
                        ),
                      ],
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