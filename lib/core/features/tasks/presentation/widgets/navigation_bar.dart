import 'package:flutter/material.dart';
import 'package:task_manager/core/features/comments/presentation/screens/comment_screen.dart';
import 'package:task_manager/core/features/dashboard/presentation/screens/dash.dart';
import 'package:task_manager/core/features/profile/presentation/screens/profile_screen.dart';
import 'package:task_manager/core/features/tasks/presentation/screens/task_screen.dart';

class TaskBottomBar extends StatefulWidget {
  TaskBottomBar({super.key});

  @override
  State<TaskBottomBar> createState() => _TaskBottomBarState();
}

class _TaskBottomBarState extends State<TaskBottomBar> {
  int _selectedIndex = 0;
  List<Widget> pages = [
    DashBoardScreen(),
    TaskScreen(),
    CommentScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
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
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        showUnselectedLabels: true,
        selectedItemColor: Colors.lightBlue,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "DashBorad"),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tasks"),

          BottomNavigationBarItem(icon: Icon(Icons.comment), label: "Comments"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
