import 'package:flutter/material.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/drawer.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/navigation_bar.dart';
import 'package:task_manager/core/permission/permission_manger.dart';
import 'package:task_manager/core/permission/role.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: DrawerHome(role: UserRole.developer),
      bottomNavigationBar: TaskBottomBar(),
      body: Column(
        children: [
          Text("Settings Screen"),

          Text("Hello "),
          Row(
            children: [
              Text("Log Out"),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.login_outlined, color: Colors.lightBlue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
