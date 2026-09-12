import 'package:flutter/material.dart';
import 'package:task_manager/core/features/tasks/domain/entities/task_entity.dart';
import 'package:task_manager/core/features/tasks/presentation/screens/task_details.dart';

class TaskList extends StatelessWidget {
  final List<TaskEntity> tasks;
  const TaskList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(child: Text("No Tasks Found"));
    }
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          child: ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
            trailing: Text(task.priority),
            leading: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TaskDetails(task: task)),
                );
              },
              child: Text('Task Details'),
            ),
          ),
        );
      },
    );
  }
}
