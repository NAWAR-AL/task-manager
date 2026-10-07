import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/app_widgets/app_widgets.dart';
import 'package:task_manager/core/features/app_widgets/drawer.dart';
import 'package:task_manager/core/features/project_management/data/models/project_model.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/project_cubit.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/projects_state.dart';
import 'package:task_manager/core/permission/role.dart';

import '../../../auth/presentation/cubit/logout_cubit.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({super.key});

  @override
  State<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedStatus = 'active';
  bool _isCreating = false;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    setState(() => _isCreating = true);

    context.read<ProjectCubit>().createProject(
      ProjectModel(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        status: selectedStatus,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProjectCubit, ProjectsState>(
      listener: (context, state) {
        if (state is ProjectCreated) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Project created successfully'),
                backgroundColor: Colors.green,
              ),
            );
          Navigator.pop(context);
        }
        if (state is ProjectError) {
          setState(() => _isCreating = false);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Project'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        drawer: const DrawerHome(role: UserRole.admin),
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
                      text: 'Project details',
                      icon: Icons.folder_outlined,
                    ),
                    const SizedBox(height: 18),
                    AppTextField(
                      controller: nameController,
                      label: 'Project name',
                      hint: 'e.g. Orbit Mobile App',
                      prefixIcon: Icons.title,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a project name';
                        }
                        if (value.trim().length < 3) {
                          return 'Name must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: descriptionController,
                      label: 'Description',
                      hint: 'What is this project about?',
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
                label: 'Create Project',
                icon: Icons.add_rounded,
                loading: _isCreating,
                onPressed: _submit,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, size: 18),
                label: const Text('Cancel'),
              ),
              ElevatedButton(
                          style:  ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 243, 112, 103),
                            ),

                            foregroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                          ),

                          onPressed: () {
                            context.read<LogoutCubit>().logout();
                          },

                          child:  Text("Logout"),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}