import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:task_manager/core/features/app_widgets/drawer.dart';
import 'package:task_manager/core/features/profile/presentation/profile_bloc/task_bloc.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/task_field.dart';
import 'package:task_manager/core/permission/role.dart';

class CreatetaskPage extends StatefulWidget {
  CreatetaskPage({super.key});

  @override
  State<CreatetaskPage> createState() => _CreatetaskPageState();
}

class _CreatetaskPageState extends State<CreatetaskPage> {
  final taskTitleController = TextEditingController();
  final projectColtoller = TextEditingController();
  final descriptionController = TextEditingController();

  // String selectedStatus = 'active';

  @override
  void dispose() {
    taskTitleController.dispose();
    descriptionController.dispose();
    projectColtoller.dispose();
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
            icon: Icon(Icons.edit_outlined, color: Colors.lightBlue),
          ),
        ],
      ),
      drawer: DrawerHome(role: UserRole.admin),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Form(
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
                // Container(
                //   padding: const EdgeInsets.only(left: 8, right: 8.0),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(8.0),
                //     color: Colors.blueGrey.shade100,
                //   ),
                //   child: DropdownButtonFormField<String>(
                //     initialValue: selectedStatus,
                //     decoration: InputDecoration(labelText: 'Status'),
                //     items: [
                //       DropdownMenuItem(value: 'active', child: Text('Active')),
                //       DropdownMenuItem(
                //         value: 'on_hold',
                //         child: Text('On Hold'),
                //       ),
                //       DropdownMenuItem(
                //         value: 'completed',
                //         child: Text('Completed'),
                //       ),
                //     ],
                //     onChanged: (value) {
                //       if (value != null) {
                //         setState(() {
                //           selectedStatus = value;
                //         });
                //       }
                //     },
                //   ),
                // ),

                Gap(30),

                ElevatedButton(
                  onPressed: () {
                    context.read<TaskBloc>().createtaskUsecase;
                  },
                  child: Text('Create Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
