import 'package:flutter/material.dart';
import 'package:task_manager/core/features/app_widgets/drawer.dart';
import 'package:task_manager/core/permission/role.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Hello ')),
      drawer: DrawerHome(role: UserRole.developer),
      // bottomNavigationBar: TaskBottomBar(role: UserRole.developer),
      body: Center(child: Text("Users Magement")),
    );
  }
}
