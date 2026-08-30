import 'package:flutter/material.dart';
import 'package:task_manager/core/features/comments/presentation/screens/comment_screen.dart';
import 'package:task_manager/core/features/dashboard/presentation/screens/dashscreen.dart';
import 'package:task_manager/core/features/profile/presentation/screens/profile_screen.dart';
import 'package:task_manager/core/features/tasks/presentation/screens/task.dart';

import 'package:task_manager/core/features/tasks/presentation/widgets/drawer.dart';
import 'package:task_manager/core/permission/role.dart';

class TaskBottomBar extends StatefulWidget {
  const TaskBottomBar({super.key});

  @override
  State<TaskBottomBar> createState() => _TaskBottomBarState();
}

class _TaskBottomBarState extends State<TaskBottomBar> {
  int _selectedIndex = 0;
  List<Widget> pages = [DashScreen(), Task(), CommentScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Admin DashBoard",
          style: TextStyle(
            fontSize: 14,
            color: Colors.lightBlueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          CircleAvatar(child: Center(child: Text("N"))),

          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none, color: Colors.lightBlue),
          ),
        ],
      ),
      drawer: DrawerHome(role: UserRole.admin),
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
        type: BottomNavigationBarType.fixed,
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

// import 'package:flutter/material.dart';
// import 'package:task_manager/core/features/comments/presentation/screens/comment_screen.dart';
// import 'package:task_manager/core/features/dashboard/presentation/screens/dash.dart';
// import 'package:task_manager/core/features/profile/presentation/screens/profile_screen.dart';
// import 'package:task_manager/core/features/tasks/presentation/screens/task_screen.dart';

// class TaskBottomBar extends StatefulWidget {
//   const TaskBottomBar({super.key});

//   @override
//   State<TaskBottomBar> createState() => _TaskBottomBarState();
// }

// class _TaskBottomBarState extends State<TaskBottomBar> {
//   int _selectedIndex = 0;
//   List<Widget> pages = [
//     DashBoardScreen(),
//     TaskScreen(),
//     CommentScreen(),
//     ProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       onTap: (index) {
//         setState(() {
//           _selectedIndex = index;
//         });
//       },
//       currentIndex: _selectedIndex,
//       unselectedItemColor: Colors.grey,
//       unselectedLabelStyle: TextStyle(color: Colors.grey),
//       showUnselectedLabels: true,
//       selectedItemColor: Colors.lightBlue,
//       type: BottomNavigationBarType.fixed,
//       items: <BottomNavigationBarItem>[
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: "DashBorad"),
//         BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tasks"),

//         BottomNavigationBarItem(icon: Icon(Icons.comment), label: "Comments"),
//         BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//       ],
//     );
//   }
// }
