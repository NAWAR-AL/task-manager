import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/tasks/domain/entities/task_entity.dart';
import 'package:task_manager/core/features/tasks/presentation/screens/task_details.dart';
import 'package:task_manager/core/features/tasks/presentation/task_bloc/task_bloc.dart';

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

        return Dismissible(
          key: Key(task.id.toString()),
          direction: DismissDirection.horizontal,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(' Delete task'),
                      content: Text(
                        'Are you sure you want to delete the "${task.title}"؟',
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                ) ??
                false;
          },
          onDismissed: (direction) {
            context.read<TaskBloc>().add(DeleteTaskEvent(task.id!));
          },
          child: Card(
            elevation: 2,
            color: getCardBackgoundColor(index),
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
              ),
            ),
          ),
        );
      },
    );
  }
}

Color getCardBackgoundColor(int index) {
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
