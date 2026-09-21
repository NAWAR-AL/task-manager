import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/features/app_widgets/drawer.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_cubit.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_state.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/project_cubit.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/projects_state.dart';
import 'package:task_manager/core/features/tasks/domain/entities/task_entity.dart';
import 'package:task_manager/core/features/tasks/presentation/task_bloc/task_bloc.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/task_field.dart';
import 'package:task_manager/core/permission/role.dart';

class UpdateTaskPage extends StatefulWidget {
  final TaskEntity updatedTask;
  UpdateTaskPage({super.key, required this.updatedTask});

  @override
  State<UpdateTaskPage> createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final taskTitleController = TextEditingController();
  final descriptionController = TextEditingController();

  String? selectedPriority;
  DateTime? selectedDueDate;
  String? selectedStatus;
  int? selectedProjectId;
  final List<int> selectedDeveloperIds = [];

  Future<void> pickDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != selectedDueDate) {
      setState(() {
        selectedDueDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    taskTitleController.text = widget.updatedTask.title;
    descriptionController.text = widget.updatedTask.description;
    selectedPriority = widget.updatedTask.priority;
    selectedProjectId = widget.updatedTask.project_id;
    selectedDueDate = widget.updatedTask.due_date;
    selectedStatus = widget.updatedTask.status;
    if (widget.updatedTask.assigned_users != null) {
      selectedDeveloperIds.addAll(widget.updatedTask.assigned_users!);
    }

    context.read<ProjectCubit>().fetchProjects();
    context.read<ProfileCubit>().getusers();
  }

  @override
  void dispose() {
    taskTitleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Update Task"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: DrawerHome(role: UserRole.admin),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: BlocListener<TaskBloc, TaskState>(
          listener: (context, state) {
            if (state is TaskUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Task updated successfully')),
              );
              Navigator.pop(context);
            }
            if (state is TaskError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TaskField(
                  fieldController: taskTitleController,
                  fieldLabel: 'Task Title',
                ),

                Gap(30),
                TaskField(
                  fieldController: descriptionController,
                  fieldLabel: 'Task Description',
                ),

                Gap(30),

                Container(
                  padding: const EdgeInsets.only(left: 8, right: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Color(0xffCCFBFA),
                  ),

                  child: BlocBuilder<ProjectCubit, ProjectsState>(
                    builder: (context, state) {
                      if (state is ProjectsLoading) {
                        return CircularProgressIndicator();
                      }
                      if (state is ProjectsLoaded) {
                        return DropdownButtonFormField<int>(
                          initialValue: selectedProjectId,
                          decoration: InputDecoration(
                            labelText: 'Select Project',
                            border: InputBorder.none,
                          ),
                          items: state.projects.map((project) {
                            return DropdownMenuItem<int>(
                              value: project.id,
                              child: Text(project.name),
                            );
                          }).toList(),
                          onChanged: ((value) {
                            setState(() {
                              selectedProjectId = value;
                            });
                          }),
                        );
                      }
                      if (state is ProjectsError) {
                        return Text('Error: ${state.message}');
                      }
                      return Text('No Projects Yet');
                    },
                  ),
                ),
                Gap(30),
                Container(
                  padding: const EdgeInsets.only(left: 8, right: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Color(0xffCCFBFA),
                  ),
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedPriority,
                    decoration: const InputDecoration(
                      labelText: 'Select Priority',
                      border: InputBorder.none,
                    ),
                    hint: Text("Select Priority"),
                    items: ['low', 'medium', 'high']
                        .map(
                          (priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(priority),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() {
                      selectedPriority = value;
                    }),
                  ),
                ),
                Gap(30),
                Container(
                  padding: const EdgeInsets.only(left: 8, right: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Color(0xffCCFBFA),
                  ),
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Select Status',
                      border: InputBorder.none,
                    ),
                    hint: Text("Select Status"),
                    items: ['todo', 'in_progress', 'review', 'done']
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() {
                      selectedStatus = value;
                    }),
                  ),
                ),
                Gap(30),
                Container(
                  padding: const EdgeInsets.only(left: 8, right: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Color(0xffCCFBFA),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assign Developers',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      BlocBuilder<ProfileCubit, ProfileState>(
                        builder: ((context, state) {
                          if (state is UsersLoaded) {
                            final developers = state.users
                                .where((user) => user.role == 'developer')
                                .toList();
                            return Column(
                              children: developers.map((dev) {
                                return CheckboxListTile(
                                  activeColor: Color(0xffF7ADAD),
                                  checkColor: Color(0xffCCFBFA),
                                  value: selectedDeveloperIds.contains(dev.id),
                                  title: Text(dev.name),
                                  onChanged: (bool? checked) {
                                    setState(() {
                                      if (checked == true) {
                                        selectedDeveloperIds.add(dev.id);
                                      } else {
                                        selectedDeveloperIds.remove(dev.id);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            );
                          }
                          if (state is UserErorr) {
                            // print('error for updatedtask is ${state.message}');
                            return Center(child: Text(state.message));
                          }
                          return Text('No Developer Yet');
                        }),
                      ),
                    ],
                  ),
                ),

                Gap(30),
                Container(
                  padding: const EdgeInsets.only(left: 8, right: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Color(0xffCCFBFA),
                  ),
                  child: InkWell(
                    onTap: pickDueDate,
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: Color(0xffF7ADAD),
                        ),
                        Text(
                          selectedDueDate == null
                              ? 'Select Date'
                              : DateFormat(
                                  'yyyy-MM-dd',
                                ).format(selectedDueDate!),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(30),

                BlocListener<TaskBloc, TaskState>(
                  listener: (context, state) {
                    if (state is TaskCreated) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Task Created Successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    } else if (state is TaskError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffB1E5E6),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (!(_formKey.currentState?.validate() ?? false)) return;
                      if (selectedProjectId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please select a Project')),
                        );
                        return;
                      }
                      if (selectedDueDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please select a due Date')),
                        );
                        return;
                      }
                      final taskEntity = TaskEntity(
                        id: widget.updatedTask.id,
                        title: taskTitleController.text.trim(),
                        description: descriptionController.text.trim(),
                        project_id: selectedProjectId!,
                        assigned_users: selectedDeveloperIds,
                        due_date: selectedDueDate!,
                        priority: selectedPriority ?? 'low',
                        status: selectedStatus ?? 'todo',
                      );
                      context.read<TaskBloc>().add(UpdateTaskEvent(taskEntity));
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: ((context) => TaskPage())),
                      // );
                    },
                    child: Text(
                      'Updated Task',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
