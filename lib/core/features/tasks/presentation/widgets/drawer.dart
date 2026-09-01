import 'package:flutter/material.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/create_project_page.dart';
import 'package:task_manager/core/features/settings/screens/setting_screen.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/navigation_bar.dart';
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
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 36, color: Colors.blueGrey),
            ),
            margin: const EdgeInsets.only(bottom: 20),
            accountEmail: Text("${role.name}@Orbit.com"),
            accountName: Text(
              role.name.toUpperCase(),
              style: TextStyle(fontSize: 18.0),
            ),
            decoration: const BoxDecoration(color: Colors.blueGrey),
          ),

          drawerItem(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            ontap: () {
              navigateToScreen(context, TaskBottomBar(role: UserRole.admin));
            },
          ),

          if (PermissionManager.can(role, Permission.readProject))
            drawerItem(
              icon: Icons.folder_outlined,
              title: 'Projects',
              ontap: () {
                navigateToScreen(context, CreateProjectPage());
              },
            ),

          if (PermissionManager.can(role, Permission.readUser))
            drawerItem(
              icon: Icons.people_outline,
              title: 'Users',
              ontap: () {
                navigateToScreen(context, UserScreen());
              },
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Divider(),
          ),
          drawerItem(
            icon: Icons.calendar_month_outlined,
            title: 'Calender',
            ontap: () {
              Navigator.pop(context);
            },
          ),

          drawerItem(
            icon: Icons.report_outlined,
            title: 'Reports',
            ontap: () {
              Navigator.pop(context);
            },
          ),
          drawerItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            ontap: () {
              navigateToScreen(context, SettingsScreen());
            },
          ),
        ],
      ),
    );
  }
}

Widget drawerItem({
  required IconData icon,
  required String title,
  required VoidCallback ontap,
}) {
  return ListTile(
    title: Text(
      title,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
    leading: Icon(icon, color: Colors.lightBlue),
    onTap: ontap,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(8),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
  );
}

void navigateToScreen(BuildContext context, Widget screen) {
  Navigator.pop(context);
  Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
}
