import 'package:flutter/material.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/drawer.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/navigation_bar.dart';
import 'package:task_manager/core/permission/role.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: DrawerHome(role: UserRole.admin),
      bottomNavigationBar: TaskBottomBar(),
      body: Column(children: [Text("Project Screen")]),
    );
  }
}
