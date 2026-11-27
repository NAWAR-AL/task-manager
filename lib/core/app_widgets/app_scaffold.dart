import 'package:flutter/material.dart';
import 'package:task_manager/core/app_widgets/app_widgets.dart';
import 'package:task_manager/core/app_widgets/colors.dart';
import 'package:task_manager/core/app_widgets/drawer.dart';
import 'package:task_manager/core/permission/role.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final UserRole role;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final List<Widget>? actions;
  const AppScaffold({
    super.key,
    required this.body,
    required this.title,
    required this.role,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final List<DateTime> monthDays = List.generate(
      7,
      (index) => DateTime.now().add(Duration(days: index)),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontSize: isLandscape ? 18 : 22,
            fontWeight: FontWeight.w700,
            color: ColorsApp.textPrimary,
          ),
        ),
        actions: actions ?? [UserName(isAvater: true), LogoutButton()],
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: DrawerHome(role: role),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
