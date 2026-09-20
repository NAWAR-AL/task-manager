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
          elevation: 2,
          color: _getCardBackgoundColor(index),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TaskDetails(task: task)),
              );
            },
            child: ListTile(
              trailing: Container(
                width: 20,
                height: 30,
                decoration: BoxDecoration(
                  color: _getPriorityColor(task.priority),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              title: Text(
                task.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              leading: Text(
                task.priority.toUpperCase(),
                style: TextStyle(fontSize: 12),
              ),

              // trailing: Row(
              //   children: [
              //     Chip(
              //       label: Text(task.status),
              //       backgroundColor: _getStatusColor(task.status),
              //       visualDensity: VisualDensity.compact,
              //     ),
              //     Icon(Icons.arrow_forward_ios),
              //   ],
              // ),
            ),
            // child: ListTile(
            //   title: Text(task.title),
            //   subtitle: Text(task.priority),
            //   trailing: Text(task.status),
            //   leading: Text(task.title),
            // ),
          ),
        );
      },
    );
  }
}

Color _getCardBackgoundColor(int index) {
  switch (index % 3) {
    case 0:
      return Color(0xff9BCEC1);
    case 1:
      return Color(0xffFFEBD3);
    case 2:
      return Color(0xffFFB6A6);
    default:
      return Color(0xff9BCEC1);
  }
}

Color _getPriorityColor(String priority) {
  switch (priority.toLowerCase()) {
    case 'high':
      return Colors.red;
    case 'medium':
      return Colors.orange;
    case 'low':
      return Colors.green;
    default:
      return Colors.green;
  }
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'in_progress':
      return Colors.orangeAccent;
    case 'review':
      return Colors.blue;
    case 'done':
      return Colors.green;
    default:
      return Colors.green;
  }
}
