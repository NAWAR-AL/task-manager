import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/features/tasks/domain/entities/task_entity.dart';

class TaskDetails extends StatelessWidget {
  final TaskEntity task;
  const TaskDetails({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(task.due_date.toString());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(task.title, style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit_outlined),
            color: Color(0xffF7ADAD),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description: ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xffCCFBFA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                task.description.isEmpty
                    ? 'No description provided'
                    : task.description,
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDetailRow(
                      icon: Icons.calendar_today_outlined,
                      title: 'Due Date:',
                      value: DateFormat(
                        'dd MM yyyy hh:mm a',
                      ).format(DateTime.parse(dateTime.toString())),
                    ),
                    Divider(height: 20),
                    _buildDetailRow(
                      icon: Icons.work_outline,
                      title: 'Project ID',
                      value: task.project_id.toString(),
                    ),
                    _buildDetailRow(
                      icon: Icons.person_outline,
                      title: 'Created By',
                      value: task.created_by?.toString() ?? 'N/A',
                    ),
                  ],
                ),
              ),
            ),

            Divider(height: 20),
            Text('Assigned Developer '),
            task.assigned_users != null && task.assigned_users!.isNotEmpty
                ? Wrap(
                    spacing: 8,
                    children: task.assigned_users!.map((devId) {
                      return Chip(
                        avatar: CircleAvatar(
                          backgroundColor: Colors.lightBlue,
                          child: Icon(
                            Icons.person,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                        label: Text('Developer #$devId'),
                      );
                    }).toList(),
                  )
                : Text('No Developers assgined yet'),
            Text('Add a Comment'),

            TextField(
              decoration: InputDecoration(
                hintText: 'Write your  comment',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey),
                ),
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

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.lightBlue),

        Text(title, style: TextStyle(fontSize: 15, color: Colors.black)),
        SizedBox(width: 12),
        Text(value, style: TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
