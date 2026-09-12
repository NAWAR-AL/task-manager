import 'package:flutter/material.dart';
import 'package:task_manager/core/features/app_widgets/drawer.dart';
import 'package:task_manager/core/permission/role.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: DrawerHome(role: UserRole.developer),

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
