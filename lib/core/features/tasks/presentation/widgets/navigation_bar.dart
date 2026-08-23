import 'package:flutter/material.dart';

class TaskBottomBar extends StatelessWidget {
  const TaskBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.lightBlue,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.date_range_outlined),
          label: "Scheduel",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tasks"),
        BottomNavigationBarItem(
          icon: Icon(Icons.note_add_outlined),
          label: "Projects",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.comment), label: "Comments"),
      ],
    );
  }
}
