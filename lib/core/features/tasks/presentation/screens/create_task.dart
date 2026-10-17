import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:task_manager/core/features/app_widgets/app_widgets.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/app_widgets/drawer.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_cubit.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_state.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/project_cubit.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/projects_state.dart';
import 'package:task_manager/core/features/tasks/domain/entities/task_entity.dart';
import 'package:task_manager/core/features/tasks/presentation/task_bloc/task_bloc.dart';
import 'package:task_manager/core/permission/role.dart';

class CreatetaskPage extends StatefulWidget {
  final UserRole role;
  const CreatetaskPage({super.key, required this.role});

  @override
  State<CreatetaskPage> createState() => _CreatetaskPageState();
}

class _CreatetaskPageState extends State<CreatetaskPage> {
  final _formKey = GlobalKey<FormState>();
  final taskTitleController = TextEditingController();
  final descriptionController = TextEditingController();
  final MultiSelectController<int> _dropdownDeveloper = MultiSelectController();
  String? selectedPriority;
  DateTime? selectedDueDate;
  String? selectedStatus;
  int? selectedProjectId;
  List<int> selectedDeveloperIds = [];
  bool _isCreating = false;

  Future<void> pickDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => selectedDueDate = picked);
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

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (selectedProjectId == null) {
      _toast('Please select a project', danger: true);
      return;
    }
    if (selectedDueDate == null) {
      _toast('Please select a due date', danger: true);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isCreating = true);

    context.read<TaskBloc>().add(
      CreateTaskEvent(
        TaskEntity(
          title: taskTitleController.text.trim(),
          description: descriptionController.text.trim(),
          project_id: selectedProjectId!,
          assigned_users: selectedDeveloperIds,
          due_date: selectedDueDate!,
          priority: selectedPriority ?? 'low',
          status: selectedStatus ?? 'todo',
        ),
      ),
    );
  }

  void _toast(String message, {bool danger = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: danger ? Colors.red : null,
        ),
      );
  }

  Widget _buildProjectDropdown() {
    return BlocBuilder<ProjectCubit, ProjectsState>(
      builder: (context, state) {
        if (state is ProjectsLoaded) {
          if (state.projects.isEmpty) {
            return const AppCard(
              child: Text(
                'No projects yet — create a project first.',
                style: TextStyle(color: ColorsApp.textSecondary),
              ),
            );
          }
          return AppDropdown<int>(
            label: 'Project',
            prefixIcon: Icons.folder_outlined,
            value: selectedProjectId,
            hint: 'Select a project',
            items: state.projects
                .map(
                  (project) => DropdownMenuItem<int>(
                    value: project.id,
                    child: Text(project.name, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => selectedProjectId = value),
          );
        }
        if (state is ProjectsError) {
          return Text(
            state.message,
            style: const TextStyle(color: ColorsApp.danger),
          );
        }
        return const LinearProgressIndicator(minHeight: 2);
      },
    );
  }

  Widget _buildDevelopers() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is UsersLoaded) {
          final developers = state.users
              .where((user) => user.role == 'developer')
              .toList();

          if (developers.isEmpty) {
            return const Text(
              'No developers available',
              style: TextStyle(color: ColorsApp.textSecondary, fontSize: 13),
            );
          }
          return MultiDropdown<int>(
            controller: _dropdownDeveloper,

            dropdownDecoration: DropdownDecoration(
              animationCurve: Curves.easeInOutCubic,
              borderRadius: BorderRadius.circular(AppRadius.field),
              animationDuration: Duration(milliseconds: 200),
              backgroundColor: ColorsApp.background,
            ),

            items: developers.map((dev) {
              return DropdownItem<int>(label: dev.name, value: dev.id);
            }).toList(),
            onSelectionChange: (selectedList) {
              selectedDeveloperIds = List<int>.from(selectedList);
            },
          );
        }
        if (state is UserErorr) {
          return Text(
            state.message,
            style: const TextStyle(color: ColorsApp.danger, fontSize: 13),
          );
        }
        return const LinearProgressIndicator(minHeight: 2);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskCreated) {
          _toast('Task created successfully');
          Navigator.pop(context);
        } else if (state is TaskError) {
          setState(() => _isCreating = false);
          _toast(state.message, danger: true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Task'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [LogoutButton()],
        ),
        drawer: DrawerHome(role: widget.role),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppSectionTitle(
                      text: 'Task info',
                      icon: Icons.task_alt_outlined,
                    ),
                    const SizedBox(height: 18),
                    AppTextField(
                      controller: taskTitleController,
                      label: 'Task title',
                      hint: 'What needs to be done?',
                      prefixIcon: Icons.title,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a task title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: descriptionController,
                      label: 'Description',
                      hint: 'Add details about this task',
                      prefixIcon: Icons.notes_outlined,
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppSectionTitle(
                      text: 'Planning',
                      icon: Icons.event_note_outlined,
                    ),
                    const SizedBox(height: 18),
                    _buildProjectDropdown(),
                    const SizedBox(height: 16),
                    AppDropdown<String>(
                      label: 'Priority',
                      prefixIcon: Icons.flag_outlined,
                      value: selectedPriority,
                      hint: 'Select priority',
                      items: const [
                        DropdownMenuItem(value: 'low', child: Text('Low')),
                        DropdownMenuItem(
                          value: 'medium',
                          child: Text('Medium'),
                        ),
                        DropdownMenuItem(value: 'high', child: Text('High')),
                      ],
                      onChanged: (value) =>
                          setState(() => selectedPriority = value),
                    ),
                    const SizedBox(height: 16),
                    AppDropdown<String>(
                      label: 'Status',
                      prefixIcon: Icons.radio_button_checked_outlined,
                      value: selectedStatus,
                      hint: 'Select status',
                      items: const [
                        DropdownMenuItem(value: 'todo', child: Text('To Do')),
                        DropdownMenuItem(
                          value: 'in_progress',
                          child: Text('In Progress'),
                        ),
                        DropdownMenuItem(
                          value: 'review',
                          child: Text('Review'),
                        ),
                        DropdownMenuItem(value: 'done', child: Text('Done')),
                      ],
                      onChanged: (value) =>
                          setState(() => selectedStatus = value),
                    ),
                    const SizedBox(height: 16),
                    AppDateField(
                      label: 'Due date',
                      value: selectedDueDate == null
                          ? null
                          : DateFormat('dd MMM yyyy').format(selectedDueDate!),
                      onTap: pickDueDate,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppSectionTitle(
                      text: 'Assign developers',
                      icon: Icons.group_outlined,
                    ),
                    const SizedBox(height: 14),
                    _buildDevelopers(),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Create Task',
                icon: Icons.add_rounded,
                loading: _isCreating,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
