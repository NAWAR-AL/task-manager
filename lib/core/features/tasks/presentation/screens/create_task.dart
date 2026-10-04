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
import 'package:task_manager/core/features/tasks/presentation/screens/task.dart';
import 'package:task_manager/core/features/tasks/presentation/task_bloc/task_bloc.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/task_field.dart';
import 'package:task_manager/core/permission/role.dart';

class CreatetaskPage extends StatefulWidget {
  const CreatetaskPage({super.key});

  @override
  State<CreatetaskPage> createState() => _CreatetaskPageState();
}

class _CreatetaskPageState extends State<CreatetaskPage> {
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
      lastDate: DateTime(2030),
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
    context.read<ProjectCubit>().fetchProjects();
    context.read<ProfileCubit>().getDashboardusers();
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
        title: const Text("Create Task"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: DrawerHome(role: UserRole.admin),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TaskField(
                  fieldController: taskTitleController,
                  fieldLabel: 'Task Title',
                ),

                const Gap(30),
                TaskField(
                  fieldController: descriptionController,
                  fieldLabel: 'Task Description',
                ),

                const Gap(30),

                BlocBuilder<ProjectCubit, ProjectsState>(
                  builder: (context, state) {
                    if (state is ProjectsLoading) {
                      return const CircularProgressIndicator();
                    }
                    if (state is ProjectsLoaded) {
                      return Container(
                        padding: const EdgeInsets.only(left: 8, right: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: const Color(0xffCCFBFA),
                        ),
                        child: DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
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
                        ),
                      );
                    }
                    if (state is ProjectsError) {
                      return Text('Error: ${state.message}');
                    }
                    return const Text('No Projects Yet');
                  },
                ),

                const Gap(30),
                Container(
                  padding: const EdgeInsets.only(left: 8, right: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: const Color(0xffB1E5E6),
                  ),
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedPriority,
                    decoration: const InputDecoration(
                      labelText: 'Select Priority',
                      border: InputBorder.none,
                    ),
                    hint: const Text("Select Priority"),
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

                const Gap(30),
                Container(
                  padding: const EdgeInsets.only(left: 8, right: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: const Color(0xffF7ADAD),
                  ),
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Select Status',
                      border: InputBorder.none,
                    ),
                    hint: const Text("Select Status"),
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

                const Gap(30),

                // قسم اختيار المطورين (تم تنظيف التكرار)
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: const Color(0xffF29191),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
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
                                  activeColor: const Color(0xffF7ADAD),
                                  checkColor: const Color(0xffCCFBFA),
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
                            return Center(child: Text(state.message));
                          }
                          return const Text('No Developer Yet');
                        }),
                      ),
                    ],
                  ),
                ),

                const Gap(30),

                // اختيار تاريخ الاستحقاق
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: const Color(0xffB1E5E6),
                  ),
                  child: InkWell(
                    onTap: pickDueDate,
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: Color(0xffF7ADAD),
                        ),
                        const SizedBox(width: 8),
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

                const Gap(30),

                // زر الإنشاء والمستمع
                BlocListener<TaskBloc, TaskState>(
                  listener: (context, state) {
                    if (state is TaskCreated) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
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
                      backgroundColor: const Color(0xffB1E5E6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (!(_formKey.currentState?.validate() ?? false)) return;
                      if (selectedProjectId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a Project'),
                          ),
                        );
                        return;
                      }
                      if (selectedDueDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a due Date'),
                          ),
                        );
                        return;
                      }
                      final taskEntity = TaskEntity(
                        title: taskTitleController.text.trim(),
                        description: descriptionController.text.trim(),
                        project_id: selectedProjectId!,
                        assigned_users: selectedDeveloperIds,
                        due_date: selectedDueDate!,
                        priority: selectedPriority ?? 'low',
                        status: selectedStatus ?? 'todo',
                      );
                      context.read<TaskBloc>().add(CreateTaskEvent(taskEntity));

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TaskPage()),
                      );
                    },
                    child: const Text(
                      'Create Task',
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
