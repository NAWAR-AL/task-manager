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

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(widget.task.due_date.toString());
    DateTime createTime = DateTime.parse(widget.task.created_at.toString());
    DateTime updateTime = DateTime.parse(widget.task.updated_at.toString());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.task.title,
          style: TextStyle(color: Color(0xffB1E5E6)),
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
            icon: Icon(Icons.edit_outlined),
            color: Color(0xffF7ADAD),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Task Detailes',
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
            ),

            Card(
              elevation: 2,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
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
                      value: DateFormat(
                        'dd MM yyyy hh:mm a',
                      ).format(DateTime.parse(dateTime.toString())),
                    ),

                    BlocBuilder<ProjectCubit, ProjectsState>(
                      builder: (context, state) {
                        String projectName =
                            'project ${widget.task.project_id}';
                        if (state is ProjectsLoaded) {
                          final project = state.projects.firstWhere(
                            (p) => p.id == widget.task.project_id,
                          );
                          projectName = project.name;
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
                      value: DateFormat(
                        'dd MM yyyy hh:mm a',
                      ).format(DateTime.parse(createTime.toString())),
                    ),

                    buildDetailRow(
                      icon: Icons.update_sharp,
                      title: 'Updated At:',
                      value: DateFormat(
                        'dd MM yyyy hh:mm a',
                      ).format(DateTime.parse(updateTime.toString())),
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
                                final developer = state.users.firstWhere(
                                  (p) => p.id == devId,
                                );
                                developerName = developer.name;
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
                    Divider(height: 20),
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
                      child: Text('More comments'),
                    ),
                    TaskField(
                      fieldController: commentController,
                      fieldLabel: 'Add Comment',
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffB1E5E6),

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
                      child: Text('Add Comment'),
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

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.lightBlue),

        Text(title, style: TextStyle(fontSize: 15, color: Colors.black)),
        SizedBox(width: 12),
        Text(value, style: TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
