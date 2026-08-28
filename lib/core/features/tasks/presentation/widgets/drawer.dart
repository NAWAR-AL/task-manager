import 'package:flutter/material.dart';
import 'package:task_manager/core/features/dashboard/presentation/screens/dash.dart';
import 'package:task_manager/core/features/project_management/presentation/screens/project_screen.dart';
import 'package:task_manager/core/features/settings/screens/setting_screen.dart';
import 'package:task_manager/core/features/users_mangment/presentation/user.dart';
import 'package:task_manager/core/permission/permission.dart';
import 'package:task_manager/core/permission/permission_manger.dart';
import 'package:task_manager/core/permission/role.dart';

class DrawerHome extends StatelessWidget {
  final UserRole role;
  DrawerHome({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person, size: 40, color: Colors.lightBlue),
            ),
            margin: const EdgeInsets.only(bottom: 20),
            accountEmail: Text("${role.name}@Orbit.com"),
            accountName: Text(
              role.name.toUpperCase(),
              style: TextStyle(fontSize: 18.0),
            ),
            decoration: const BoxDecoration(color: Colors.blueGrey),
          ),
          ListTile(
            title: Text("DashBoard"),
            leading: Icon(Icons.dashboard_outlined, color: Colors.lightBlue),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => DashBoardScreen()),
              );
            },
          ),
          if (PermissionManager.can(role, Permission.readProject))
            ListTile(
              title: Text("Project"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => ProjectScreen()),
                );
              },
              leading: Icon(Icons.folder_outlined, color: Colors.lightBlue),
            ),
          if (PermissionManager.can(role, Permission.readUser))
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => UserScreen()),
                );
              },
              title: Text("Users"),
              leading: Icon(Icons.people_outline, color: Colors.lightBlue),
            ),
          const Divider(),
          ListTile(
            title: Text("Calender"),
            onTap: () {},
            leading: Icon(
              Icons.calendar_month_outlined,
              color: Colors.lightBlue,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (_) => SettingsScreen()),
              // );
            },
            title: Text("Reports"),
            leading: Icon(Icons.report_outlined, color: Colors.lightBlue),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => SettingsScreen()),
              );
            },
            title: Text("Settings"),
            leading: Icon(Icons.settings_outlined, color: Colors.lightBlue),
          ),
        ],
      ),
    );
  }
}
