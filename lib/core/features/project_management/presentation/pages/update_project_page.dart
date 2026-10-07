import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/app_widgets/app_widgets.dart';
import 'package:task_manager/core/features/project_management/domain/entities/project.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/project_cubit.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/projects_state.dart';

class UpdateProjectPage extends StatefulWidget {
  final ProjectEntity project;

  const UpdateProjectPage({super.key, required this.project});

  @override
  State<UpdateProjectPage> createState() => _UpdateProjectPageState();
}

class _UpdateProjectPageState extends State<UpdateProjectPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  late String selectedStatus;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.project.name;
    descriptionController.text = widget.project.description;
    selectedStatus = widget.project.status.isEmpty ? 'active' : widget.project.status;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final projectId = widget.project.id;
    if (projectId == null) return;

    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);

    context.read<ProjectCubit>().updateProject(
      ProjectEntity(
        id: projectId,
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        status: selectedStatus,
        createdBy: widget.project.createdBy,
        createdAt: widget.project.createdAt,
        updatedAt: widget.project.updatedAt,
      ),
      projectId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProjectCubit, ProjectsState>(
      listener: (context, state) {
        if (state is ProjectUpdated) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Project updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
          Navigator.pop(context);
        }
        if (state is ProjectError) {
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Update Project'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
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
                      text: 'Edit details',
                      icon: Icons.edit_outlined,
                    ),
                    const SizedBox(height: 18),
                    AppTextField(
                      controller: nameController,
                      label: 'Project name',
                      prefixIcon: Icons.title,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a project name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: descriptionController,
                      label: 'Description',
                      prefixIcon: Icons.notes_outlined,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    AppDropdown<String>(
                      label: 'Status',
                      prefixIcon: Icons.flag_outlined,
                      value: selectedStatus,
                      items: const [
                        DropdownMenuItem(value: 'active', child: Text('Active')),
                        DropdownMenuItem(
                          value: 'on_hold',
                          child: Text('On Hold'),
                        ),
                        DropdownMenuItem(
                          value: 'completed',
                          child: Text('Completed'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedStatus = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Save Changes',
                icon: Icons.check_rounded,
                loading: _isSaving,
                onPressed: _submit,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, size: 18),
                label: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}