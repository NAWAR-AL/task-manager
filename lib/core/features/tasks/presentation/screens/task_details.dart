import 'package:flutter/material.dart';
import 'package:task_manager/core/features/tasks/domain/entities/task_entity.dart';
import 'package:task_manager/core/permission/role.dart';

class TaskDetails extends StatelessWidget {
  final TaskEntity task;
  const TaskDetails({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title, style: TextStyle(color: Colors.lightBlue)),
      ),
      body: Expanded(
        child: ListView(
          children: [
            Text('Description: ${task.description}'),
            Text('Priority ${task.priority}'),
            SizedBox(height: 20),
            Text('Due Date : ${task.due_date}'),
            Divider(height: 20),
            const Text('Assigned to :'),
            ...task.assigned_users.map((devId) {
              final developer = UserRole.developer.name;
              return ListTile(
                title: Text(developer),
                leading: CircleAvatar(child: Icon(Icons.percent)),
              );
            }),

            Text('Add to a Comment'),
            TextField(
              decoration: InputDecoration(
                hintText: 'Add to a comment',
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add, color: Colors.lightBlue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
