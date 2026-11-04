import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/features/app_widgets/app_widgets.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/app_widgets/drawer.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/project_cubit.dart';
import 'package:task_manager/core/features/tasks/presentation/screens/create_task.dart';
import 'package:task_manager/core/features/tasks/presentation/screens/task_details.dart';
import 'package:task_manager/core/features/tasks/presentation/task_bloc/task_bloc.dart';
import 'package:task_manager/core/permission/permission.dart';
import 'package:task_manager/core/permission/permission_manger.dart';
import 'package:task_manager/core/permission/role.dart';

class AgendPage extends StatefulWidget {
  final UserRole role;
  const AgendPage({super.key, required this.role});

  @override
  State<AgendPage> createState() => _AgendPageState();
}

class _AgendPageState extends State<AgendPage> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    context.read<TaskBloc>().add(GetTasks());
    context.read<ProjectCubit>().fetchProjects();
  }

  Future<void> openCreateTask() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreatetaskPage(role: widget.role)),
    );
    if (!mounted) return;

    context.read<TaskBloc>().add(GetTasks());
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final List<DateTime> monthDays = List.generate(
      7,
      (index) => DateTime.now().add(Duration(days: index)),
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: ((didPop, result) async {
        if (didPop) return;
        await SystemNavigator.pop();
      }),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Agenda ',
            style: TextStyle(
              fontSize: isLandscape ? 18 : 22,
              fontWeight: FontWeight.w700,
              color: ColorsApp.textPrimary,
            ),
          ),
          actions: [LogoutButton()],
        ),
        drawer: DrawerHome(role: widget.role),
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isLandscape ? 10.0 : 20.0,
              vertical: isLandscape ? 2.0 : 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLandscape)
                  SizedBox(
                    height: 40,
                    child: Image.asset('assets/images/desgin.png'),
                  )
                else ...[
                  Image.asset('assets/images/desgin.png'),
                  const Text(
                    'Welcome to Orbit Task Management App ',
                    softWrap: true,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                ],
                SizedBox(height: isLandscape ? 2 : 4),
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(selectedDate),
                  style: TextStyle(
                    fontSize: isLandscape ? 10 : 14,
                    color: ColorsApp.textSecondary,
                  ),
                ),
                SizedBox(height: isLandscape ? 4 : 30),
                SizedBox(
                  height: isLandscape ? 48 : 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: monthDays.length,
                    itemBuilder: (context, index) {
                      final day = monthDays[index];
                      final isSelected =
                          day.year == selectedDate.year &&
                          day.month == selectedDate.month &&
                          day.day == selectedDate.day;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDate = day;
                          });
                        },
                        child: Container(
                          width: isLandscape ? 42 : 60,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? ColorsApp.primary
                                : ColorsApp.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? ColorsApp.primary
                                  : ColorsApp.divider,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('E').format(day),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white70
                                      : ColorsApp.textSecondary,
                                  fontSize: isLandscape ? 8 : 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: isLandscape ? 0 : 6),
                              Text(
                                day.day.toString(),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : ColorsApp.textPrimary,
                                  fontSize: isLandscape ? 12 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: isLandscape ? 4 : 20),

                Expanded(
                  child: BlocBuilder<TaskBloc, TaskState>(
                    builder: (context, state) {
                      if (state is TaskLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is TaskLoaded) {
                        final filteredTasks = state.tasks.where((task) {
                          try {
                            final dueDate = DateTime.parse(
                              task.due_date.toString(),
                            );
                            return dueDate.year == selectedDate.year &&
                                dueDate.month == selectedDate.month &&
                                dueDate.day == selectedDate.day;
                          } catch (e) {
                            return false;
                          }
                        }).toList();

                        if (filteredTasks.isEmpty) {
                          return Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.event_available,
                                    size: isLandscape ? 32 : 50,
                                    color: ColorsApp.textSecondary,
                                  ),
                                  SizedBox(height: isLandscape ? 4 : 10),
                                  Text(
                                    'No tasks for this day',
                                    style: TextStyle(
                                      color: ColorsApp.textSecondary,
                                      fontSize: isLandscape ? 11 : 14,
                                    ),
                                  ),

                                  if (PermissionManager.can(
                                    widget.role,
                                    Permission.createProject,
                                  )) ...[
                                    TextButton(
                                      onPressed: () {
                                        openCreateTask();
                                      },
                                      child: Text(
                                        " Add New Task ",
                                        style: TextStyle(
                                          color: ColorsApp.primary,
                                          fontSize: isLandscape ? 12 : 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = filteredTasks[index];

                            final bool isEven = index % 2 == 0;
                            final cardColor = isEven
                                ? ColorsApp.background2
                                : ColorsApp.background3;

                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TaskDetails(
                                          task: task,
                                          role: widget.role,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: EdgeInsets.all(isLandscape ? 8 : 16),
                                    decoration: BoxDecoration(
                                      color: cardColor,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Task Title: ${task.title}',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: ColorsApp.textPrimary,
                                                  fontSize: isLandscape ? 13 : 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),

                                              SizedBox(height: isLandscape ? 2 : 6),
                                              Text(
                                                'Status: ${task.status}',
                                                style: TextStyle(
                                                  color: ColorsApp.textSecondary,
                                                  fontSize: isLandscape ? 10 : 13,
                                                ),
                                              ),
                                              SizedBox(height: isLandscape ? 1 : 6),
                                              Text(
                                                'Priority: ${task.priority}',
                                                style: TextStyle(
                                                  color: ColorsApp.textSecondary,
                                                  fontSize: isLandscape ? 10 : 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => TaskDetails(
                                                      task: task,
                                                      role: widget.role,
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.visibility_outlined,
                                                color: ColorsApp.primary,
                                                size: isLandscape ? 18 : 24,
                                              ),
                                            ),
                                            SizedBox(height: isLandscape ? 2 : 6),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                              onPressed: () {
                                                _showDeleteConfirmationDialog(
                                                  context,
                                                  task.id!,
                                                  task.title,
                                                );
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                                size: isLandscape ? 14 : 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      return const Center(
                        child: Text("Please check your internet connection"),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // دالة مساعدة عامة لحذف المهمة من أي مكان في التطبيق
  void _showDeleteConfirmationDialog(
    BuildContext context,
    int taskId,
    String taskTitle,
  ) {
    showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete task'),
        content: Text('Are you sure you want to delete "$taskTitle"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(true);

              // 1. إرسال الحدث للـ Bloc للحذف
              context.read<TaskBloc>().add(DeleteTaskEvent(taskId));

              // 2. إظهار رسالة النجاح
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('"$taskTitle" deleted'),
                    backgroundColor: ColorsApp.danger,
                  ),
                );
            },
            style: TextButton.styleFrom(foregroundColor: ColorsApp.danger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
