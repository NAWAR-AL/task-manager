import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/di/injection_container.dart';
import 'package:task_manager/core/features/home/home.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/project_cubit.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/create_project_page.dart';
import 'package:task_manager/core/features/tasks/presentation/screens/task.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/app_widgets/drawer.dart';
import 'package:task_manager/core/features/auth/presentation/pages/user_profile_page.dart';
import 'package:task_manager/core/permission/role.dart';

class TaskBottomBar extends StatefulWidget {
  final UserRole role;

  /// أي تاب تتفتح فيه الصفحة (0 = Home, 1 = Tasks, 2 = Users)
  final int initialIndex;
  const TaskBottomBar({super.key, required this.role, this.initialIndex = 0});

  @override
  State<TaskBottomBar> createState() => _TaskBottomBarState();
}

class _TaskBottomBarState extends State<TaskBottomBar> {
  late int _selectedIndex = widget.initialIndex;

  List<Widget> pages = [HomePage(), TaskPage(), UserProfilePage()];

  Future<void> _openCreateProject() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<ProjectCubit>(),
          child: const CreateProjectPage(),
        ),
      ),
    );
    if (!mounted) return;
    context.read<ProjectCubit>().fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // الهيدر القديم (Welcome <role>) اتشال — كل صفحة صار عندها هيدرها الخاص
      drawer: const DrawerHome(role: UserRole.admin),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        currentIndex: _selectedIndex,
        backgroundColor: ColorsApp.surface,
        unselectedItemColor: ColorsApp.textSecondary,
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: ColorsApp.textSecondary,
        ),
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: ColorsApp.primary,
        ),
        showUnselectedLabels: true,
        selectedItemColor: ColorsApp.primary,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tasks"),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: "Users",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateProject,
        tooltip: 'New Project',
        label: const Text(
          'New Project',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        icon: const Icon(Icons.add_business, color: Colors.white),
      ),
    );
  }
}
