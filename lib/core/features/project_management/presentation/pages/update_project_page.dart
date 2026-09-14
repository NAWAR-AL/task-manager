import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../domain/entities/project.dart';
import '../../presentation/cubit/project_cubit.dart';
import '../../presentation/cubit/projects_state.dart';

class UpdateProjectPage extends StatefulWidget {
  final ProjectEntity project;

  const UpdateProjectPage({super.key, required this.project});

  @override
  State<UpdateProjectPage> createState() => _UpdateProjectPageState();
}

class _UpdateProjectPageState extends State<UpdateProjectPage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedStatus = 'active';

  @override
  void initState() {
    super.initState();

    nameController.text = widget.project.name;
    descriptionController.text = widget.project.description;
    selectedStatus = widget.project.status;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Update Project'), centerTitle: true),
      // drawer: DrawerHome(role: UserRole.admin),
      body: BlocListener<ProjectCubit, ProjectsState>(
        listener: (context, state) {
          if (state is ProjectUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Project updated successfully')),
            );

            Navigator.pop(context);
          }

          if (state is ProjectError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },

        child: Padding(
          padding: EdgeInsets.all(15),

          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Project Name'),
              ),

              Gap(15),

              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),

              Gap(15),

              DropdownButtonFormField<String>(
                initialValue: selectedStatus,

                decoration: InputDecoration(labelText: 'Status'),

                items: [
                  DropdownMenuItem(value: 'active', child: Text('Active')),

                  DropdownMenuItem(value: 'on_hold', child: Text('On Hold')),

                  DropdownMenuItem(
                    value: 'completed',
                    child: Text('Completed'),
                  ),
                ],

                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedStatus = value;
                    });
                  }
                },
              ),

              Gap(30),

              ElevatedButton(
                onPressed: () {
                  final updatedProject = ProjectEntity(
                    id: widget.project.id,
                    name: nameController.text,
                    description: descriptionController.text,
                    status: selectedStatus,
                    createdBy: widget.project.createdBy,
                    createdAt: widget.project.createdAt,
                    updatedAt: widget.project.updatedAt,
                  );

                  // context.read<ProjectCubit>().updateProject(project, id)
                },

                child: Text('Update Project'),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: TaskBottomBar(role: UserRole.admin),
    );
  }
}
