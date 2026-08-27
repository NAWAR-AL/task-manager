import 'package:flutter/material.dart';

class TaskBottomBar extends StatelessWidget {
  const TaskBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // onTap: (){},
      unselectedItemColor: Colors.grey,
      unselectedLabelStyle: TextStyle(color: Colors.grey),
      showUnselectedLabels: true,
      selectedItemColor: Colors.lightBlue,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.date_range_outlined),
          label: "Scheduel",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tasks"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorite"),
        BottomNavigationBarItem(icon: Icon(Icons.comment), label: "Comments"),
      ],
    );
  }
}
