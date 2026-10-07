import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/app_widgets/navigation_bar.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/logout_cubit.dart';
import 'package:task_manager/core/features/auth/presentation/pages/login_page.dart';
import 'package:task_manager/core/features/auth/presentation/pages/user_profile_page.dart';
import 'package:task_manager/core/features/calender/screens/calender_screen.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/projects_page.dart';
import 'package:task_manager/core/network/app_navigator.dart';
import 'package:task_manager/core/permission/permission.dart';
import 'package:task_manager/core/permission/permission_manger.dart';
import 'package:task_manager/core/permission/role.dart';

class DrawerHome extends StatelessWidget {
  final UserRole role;
  const DrawerHome({super.key, required this.role});

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Log Out'),
            content: const Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Log Out'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed || !context.mounted) return;

    // يمسح التوكن من السيرفر والمحلي، وبعدها بنرجع لشاشة اللوقن
    await context.read<LogoutCubit>().logout();
    appNavigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

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
            accountEmail: Text('Hello, ${role.name.toUpperCase()}'),
            decoration: const BoxDecoration(color: Colors.blueAccent),
          ),

          drawerItem(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            ontap: () {
              navigateToScreen(context, TaskBottomBar(role: role));
            },
          ),

          if (PermissionManager.can(role, Permission.readProject))
            drawerItem(
              icon: Icons.folder_outlined,
              title: 'Projects',
              ontap: () {
                navigateToScreen(context, const ProjectsPage());
              },
            ),

          drawerItem(
            icon: Icons.task_sharp,
            title: 'Tasks',
            ontap: () {
              navigateToScreen(
                context,
                TaskBottomBar(role: role, initialIndex: 1),
              );
            },
          ),

          if (PermissionManager.can(role, Permission.readUser))
            drawerItem(
              icon: Icons.people_outline,
              title: 'UsersMangement',
              ontap: () {
                navigateToScreen(context, const UserProfilePage());
              },
            ),

          drawerItem(
            icon: Icons.calendar_month_outlined,
            title: 'Calender',
            ontap: () {
              navigateToScreen(context, const CalenderScreen());
            },
          ),

          drawerItem(
            icon: Icons.home,
            title: 'Home',
            ontap: () {
              navigateToScreen(context, TaskBottomBar(role: role));
            },
          ),

          drawerItem(
            icon: Icons.logout,
            title: 'Log Out',
            ontap: () {
              _confirmLogout(context);
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
