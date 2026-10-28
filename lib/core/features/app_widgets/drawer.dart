import 'package:flutter/material.dart';
import 'package:task_manager/core/features/app_widgets/app_widgets.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/app_widgets/navigation_bar.dart';
import 'package:task_manager/core/permission/permission.dart';
import 'package:task_manager/core/permission/permission_manger.dart';
import 'package:task_manager/core/permission/role.dart';

class DrawerHome extends StatelessWidget {
  final UserRole role;
  const DrawerHome({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      semanticLabel: 'Task Manager',
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.png'),
              radius: 22,
              backgroundColor: Colors.white,
            ),
            margin: const EdgeInsets.only(bottom: 20),
            accountName: const Text(
              'Task Manager',
              style: TextStyle(fontSize: 18.0),
            ),
            accountEmail: Text('Hello, ${role.name}'),
            decoration: const BoxDecoration(color: Colors.blueAccent),
          ),

          drawerItem(
            icon: Icons.view_agenda,
            title: 'Agenda',
            ontap: () {
              navigateToScreen(
                context,
                TaskBottomBar(role: role, initialIndex: 1),
              );
            },
          ),
          drawerItem(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            ontap: () {
              navigateToScreen(
                context,
                TaskBottomBar(role: role, initialIndex: 0),
              );
            },
          ),
          if (PermissionManager.can(role, Permission.readProject))
            drawerItem(
              icon: Icons.folder,
              title: 'Projects',
              ontap: () {
                navigateToScreen(
                  context,
                  TaskBottomBar(role: role, initialIndex: 2),
                );
              },
            ),

          drawerItem(
            icon: Icons.task_sharp,
            title: 'Tasks',
            ontap: () {
              navigateToScreen(
                context,
                TaskBottomBar(role: role, initialIndex: 3),
              );
            },
          ),

          if (PermissionManager.can(role, Permission.readUser))
            drawerItem(
              icon: Icons.people,
              title: 'Users Mangement',
              ontap: () {
                navigateToScreen(
                  context,
                  TaskBottomBar(role: role, initialIndex: 4),
                );
              },
            ),

          drawerItem(
            icon: Icons.logout,
            title: 'Log Out',
            ontap: () {
              confirmLogout(context);
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
    leading: Icon(icon, color: ColorsApp.primary),
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
