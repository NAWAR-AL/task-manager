import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/di/injection_container.dart';
import 'package:task_manager/core/features/home/home.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/project_cubit.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/create_project_page.dart';
import 'package:task_manager/core/features/tasks/presentation/screens/task.dart';
import 'package:task_manager/core/features/app_widgets/drawer.dart';
import 'package:task_manager/core/features/auth/presentation/pages/user_profile_page.dart';
import 'package:task_manager/core/permission/role.dart';

class TaskBottomBar extends StatefulWidget {
  final UserRole role;
  const TaskBottomBar({super.key, required this.role});

  @override
  State<TaskBottomBar> createState() => _TaskBottomBarState();
}

class _TaskBottomBarState extends State<TaskBottomBar> {
  int _selectedIndex = 0;

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
      backgroundColor: Colors.white,
      // الهيدر القديم (Welcome <role>) اتشال — كل صفحة صار عندها هيدرها الخاص
      drawer: DrawerHome(role: UserRole.admin),
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
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
        showUnselectedLabels: true,
        selectedItemColor: Colors.lightBlue,
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
        backgroundColor: Colors.lightBlue,
        elevation: 10.02,
        tooltip: 'New Project',
        label: const Text(
          'New Project',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.add_business, color: Colors.white),
      ),
    );
  }
}
