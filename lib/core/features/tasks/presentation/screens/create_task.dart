import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/features/app_widgets/drawer.dart';
import 'package:task_manager/core/features/project_management/data/models/project_model.dart';
import 'package:task_manager/core/features/tasks/domain/entities/task_entity.dart';
import 'package:task_manager/core/features/tasks/presentation/task_bloc/task_bloc.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/task_field.dart';
import 'package:task_manager/core/features/users_mangment/data/user_model.dart';
import 'package:task_manager/core/permission/role.dart';

class CreatetaskPage extends StatefulWidget {
  final List<ProjectModel> projects;
  final List<UserModel> allDevelopers;
  const CreatetaskPage({
    super.key,
    this.allDevelopers = const [],
    this.projects = const [],
  });

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
  ProjectModel? selectedProject;
  final List<int> selectedDeveloperIds = [];
  // final developers = users.where((user) => user.role == 'developer').toList();
  // final List<String> allDevelopers = [];

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
        title: Text("Create Task"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: DrawerHome(role: UserRole.admin),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
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

                    color: Colors.blueGrey.shade100,
                  ),
                  child: DropdownButtonFormField<ProjectModel>(
                    initialValue: selectedProject,

                    hint: Text('Select Project'),
                    items: widget.projects.map((project) {
                      return DropdownMenuItem(
                        value: project,
                        child: Text(project.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedProject = value;
                        });
                      }
                    },
                  ),
                ),

                Gap(30),
                Container(
                  padding: const EdgeInsets.only(left: 8, right: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.blueGrey.shade100,
                  ),
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedPriority,
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
                    color: Colors.blueGrey.shade100,
                  ),
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedStatus,
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
                    color: Colors.blueGrey.shade100,
                  ),
                  child: Text(
                    'Assign Developers',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Gap(20),
                Column(
                  children: widget.allDevelopers.map((dev) {
                    return CheckboxListTile(
                      value: selectedDeveloperIds.contains(dev.id),
                      title: Text(dev.username),
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
                ),
                Gap(30),
                Container(
                  padding: const EdgeInsets.only(left: 8, right: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.blueGrey.shade100,
                  ),
                  child: InkWell(
                    onTap: pickDueDate,
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, color: Colors.blue),
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
                Gap(20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (!(_formKey.currentState?.validate() ?? false)) return;
                    if (selectedProject == null) {
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
                      title: taskTitleController.text.trim(),
                      description: descriptionController.text.trim(),
                      project_id: selectedProject!.id,
                      assigned_to: selectedDeveloperIds,

                      due_date: selectedDueDate!,
                      priority: selectedPriority ?? 'low',
                      status: selectedStatus ?? 'todo',
                      timestamps: DateTime.now(),
                    );
                    context.read<TaskBloc>().add(CreateTaskEvent(taskEntity));
                  },
                  child: Text(
                    'Create Task',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
