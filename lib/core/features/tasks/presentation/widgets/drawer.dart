import 'package:flutter/material.dart';
import 'package:task_manager/core/features/auth/data/models/login_model.dart';

class DrawerHome extends StatelessWidget {
  // final LoginModel role;
  DrawerHome({
    super.key,
    // required this.role
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person, size: 40),
            ),
            margin: EdgeInsets.only(bottom: 20),
            accountEmail: Text(""),
            accountName: Text('Developer', style: TextStyle(fontSize: 18.0)),
            decoration: BoxDecoration(color: Colors.black87),
          ),
          ListTile(
            title: Text("Calender"),
            leading: Icon(Icons.calendar_today, color: Colors.lightBlue),
          ),
          ListTile(
            title: Text("Project"),
            leading: Icon(Icons.folder, color: Colors.lightBlue),
          ),
          ListTile(
            title: Text("Settings"),
            leading: Icon(Icons.settings, color: Colors.lightBlue),
          ),
        ],
      ),
    );
  }
}
