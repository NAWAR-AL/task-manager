import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/core/di/injection_container.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_cubit.dart';
import 'package:task_manager/core/features/auth/presentation/pages/add_user.dart';
import 'package:task_manager/core/features/auth/presentation/pages/my_profile.dart';
import 'package:task_manager/core/features/dashboard/presentation/screens/dash_screen.dart';
import 'package:task_manager/core/features/home/agenda.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/project_cubit.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/create_project_page.dart';
import 'package:task_manager/core/features/project_management/presentation/pages/projects_page.dart';
import 'package:task_manager/core/features/tasks/presentation/screens/create_task.dart';
import 'package:task_manager/core/features/tasks/presentation/screens/task.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/app_widgets/drawer.dart';
import 'package:task_manager/core/features/auth/presentation/pages/user_profile_page.dart';
import 'package:task_manager/core/features/tasks/presentation/task_bloc/task_bloc.dart';
import 'package:task_manager/core/permission/permission.dart';
import 'package:task_manager/core/permission/permission_manger.dart';
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
  int currentUserId = 0;
  bool _isLoadingUser = true;
  bool get canCreateUser =>
      PermissionManager.can(widget.role, Permission.createUser);
  List<Widget> get pages => [
    DashScreen(role: widget.role),
    AgendPage(role: widget.role),
    ProjectsPage(role: widget.role),
    TaskPage(role: widget.role),
    canCreateUser
        ? UserProfilePage(role: widget.role)
        : MyProfile(userId: currentUserId),
  ];
  List<BottomNavigationBarItem> get navItems => [
    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "DashBoard"),
    BottomNavigationBarItem(icon: Icon(Icons.view_agenda), label: 'Agenda'),
    BottomNavigationBarItem(icon: Icon(Icons.folder), label: "Projects"),
    BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tasks"),
    BottomNavigationBarItem(
      icon: Icon(canCreateUser ? Icons.people : Icons.person_2),
      label: canCreateUser ? 'Users' : 'Profile',
    ),
  ];
  @override
  void initState() {
    super.initState();
    _fetchCurrentUserId();
  }

  Future<void> _fetchCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getInt('user_id') ?? prefs.getInt('id') ?? 0;

    setState(() {
      currentUserId = savedId;

      _isLoadingUser = false;
    });
  }

  Future<void> _openCreateProject() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<ProjectCubit>(),
          child: CreateProjectPage(role: widget.role),
        ),
      ),
    );
    if (!mounted) return;
    context.read<ProjectCubit>().fetchProjects();
  }

  Future<void> _openCreateUser() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => AddUser()));
    if (!mounted) return;
    // نحدّث القائمة بعد ما يرجع المستخدم من صفحة الإنشاء
    context.read<ProfileCubit>().fetchUsers();
  }

  Future<void> _openCreateTask() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreatetaskPage(role: widget.role)),
    );
    if (!mounted) return;
    // نحدّث القائمة بعد ما يرجع المستخدم من صفحة الإنشاء
    context.read<TaskBloc>().add(GetTasks());
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingUser) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      drawer: DrawerHome(role: widget.role),
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
        items: navItems,
      ),
      floatingActionButton: _getFloationgButton(),
    );
  }

  Widget? _getFloationgButton() {
    if (_selectedIndex != 2 && _selectedIndex != 3 && _selectedIndex != 4) {
      return null;
    }
    if (_selectedIndex == 2) {
      if (!PermissionManager.can(widget.role, Permission.createProject)) {
        return null;
      }
      return FloatingActionButton.extended(
        heroTag: 'unique_project',
        onPressed: _openCreateProject,
        tooltip: 'New Project',
        label: const Text(
          'New Project',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        icon: const Icon(Icons.add_business, color: Colors.white),
      );
    }
    if (_selectedIndex == 3) {
      if (!PermissionManager.can(widget.role, Permission.createTask)) {
        return null;
      }
      return FloatingActionButton.extended(
        heroTag: 'Unique_task',
        onPressed: _openCreateTask,
        tooltip: 'New Task',
        label: const Text(
          'New Task',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        icon: const Icon(Icons.add_task, color: Colors.white),
      );
    }
    if (_selectedIndex == 4) {
      if (!PermissionManager.can(widget.role, Permission.createUser)) {
        return null;
      }
      return FloatingActionButton.extended(
        heroTag: 'Unique_user',
        onPressed: _openCreateUser,
        tooltip: 'New User',
        label: const Text(
          'New User',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        icon: const Icon(Icons.person_add_alt, color: Colors.white),
      );
    }
    return null;
  }
}
