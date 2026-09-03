import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/profile/presentation/profile_bloc/task_bloc.dart';

TextEditingController taskName = TextEditingController();
TextEditingController projectName = TextEditingController();
TextEditingController status = TextEditingController();
TextEditingController timeStamp = TextEditingController();
TextEditingController description = TextEditingController();
Widget buildNewTasksTab(BuildContext context, List tasks, int index) {
  if (tasks.isEmpty) {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          Form(
            child: ListView(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    controller: taskName,
                    decoration: const InputDecoration(
                      hintText: "Task Name",
                      border: InputBorder.none,
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty || value.isEmpty) {
                        return "Please enter the Task name";
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    controller: projectName,
                    decoration: const InputDecoration(
                      hintText: "Project name",
                      border: InputBorder.none,
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty || value.isEmpty) {
                        return "Please enter your Project name";
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    controller: description,
                    decoration: const InputDecoration(
                      hintText: "Description",
                      border: InputBorder.none,
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter The Description";
                      }

                      return null;
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    controller: timeStamp,

                    decoration: const InputDecoration(
                      hintText: "Time Stamp",
                      border: InputBorder.none,
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Please enter Time stamp";
                      }
                      return "TimeStamp";
                    },
                  ),
                ),

                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    context.read<TaskBloc>().add(CreateTask(tasks[index]));
                  },
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 10.0,
                      bottom: 7.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      "Create Now",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  return Column(
    children: [
      Text('${tasks.length}'),
      TextButton(onPressed: () {}, child: Text("Add Task")),
    ],
  );
}
