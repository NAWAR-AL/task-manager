import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/update_project_page.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/drawer.dart';
import 'package:task_manager/core/permission/role.dart';
import '../../domain/entities/project.dart';
import '../../presentation/cubit/project_cubit.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({super.key});

  @override
  State<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedStatus = 'active';

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
      appBar: AppBar(
        title: Text("Create Project"),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => UpdateProjectPage(project: ,),
              //   ),
              // );
            },
            icon: Icon(Icons.edit_attributes_outlined, color: Colors.lightBlue),
          ),
        ],
      ),
      drawer: DrawerHome(role: UserRole.admin),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Project Name'),
              ),

              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),

              DropdownButtonFormField<String>(
                value: selectedStatus,
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

              ElevatedButton(onPressed: () {}, child: Text('Create Project')),
            ],
          ),
        ),
      ),
    );
  }
}
