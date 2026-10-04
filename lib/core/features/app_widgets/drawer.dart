import 'package:flutter/material.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/projects_page.dart';
import 'package:task_manager/core/features/calender/screens/calender_screen.dart';
import 'package:task_manager/core/features/app_widgets/navigation_bar.dart';
import 'package:task_manager/core/features/tasks/presentation/screens/task.dart';
import 'package:task_manager/core/features/users_mangment/presentation/user_profile.dart';
import 'package:task_manager/core/permission/permission.dart';
import 'package:task_manager/core/permission/permission_manger.dart';
import 'package:task_manager/core/permission/role.dart';

class DrawerHome extends StatelessWidget {
  final UserRole role;
  DrawerHome({super.key, required this.role});
  // final bool isDeveloper = role == UserRole.developer;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      semanticLabel: 'Task Manger',
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: ListView(
        // padding: EdgeInsets.only(bottom: 20),
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.png'),
              radius: 22,
              backgroundColor: Colors.white,
            ),
            margin: const EdgeInsets.only(bottom: 20),

            accountName: Text('Task Manger', style: TextStyle(fontSize: 18.0)),
            accountEmail: Text("Hello $role"),
            decoration: const BoxDecoration(color: Colors.blueAccent),
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
                navigateToScreen(context, ProjectsPage());
              },
            ),
          drawerItem(icon: Icons.task_sharp, title: 'Tasks', ontap: () {}),
          if (PermissionManager.can(role, Permission.readUser))
            drawerItem(
              icon: Icons.people_outline,
              title: 'UsersMangement',
              ontap: () {
                navigateToScreen(context, UserProfile());
              },
            ),

          drawerItem(
            icon: Icons.calendar_month_outlined,
            title: 'Calender',
            ontap: () {
              Navigator.pop(context);
              navigateToScreen(context, CalenderScreen());
            },
          ),

          drawerItem(
            icon: Icons.home,
            title: 'Home',
            ontap: () {
              Navigator.pop(context);
            },
          ),

          drawerItem(
            icon: Icons.logout,
            title: 'Log Out',
            ontap: () {
              AlertDialog();
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
