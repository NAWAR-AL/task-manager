import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/app_widgets/drawer.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/project_cubit.dart';
import 'package:task_manager/core/features/tasks/domain/entities/task_entity.dart';
import 'package:task_manager/core/features/tasks/presentation/task_bloc/task_bloc.dart';
import 'package:task_manager/core/permission/role.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  @override
  void initState() {
    selectedDay = focusedDay;
    context.read<TaskBloc>().add(GetTasks());
    context.read<ProjectCubit>().fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task & Projects Calender', style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      drawer: DrawerHome(role: UserRole.developer),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2025, 1, 1),
            focusedDay: focusedDay,

            lastDay: DateTime.utc(2030, 1, 1),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDay = selectedDay;
                focusedDay = focusedDay;
              });
            },
          ),
        
        ],
      ),
    );
  }
}

DateTime selectedDay = DateTime.now();
List<TaskEntity> getTasksForSelectedDay(List<TaskEntity> allTasks) {
  return allTasks.where((task) {
    return task.due_date.year == selectedDay.year &&
        task.due_date.month == selectedDay.month &&
        task.due_date.day == selectedDay.day;
  }).toList();
}
