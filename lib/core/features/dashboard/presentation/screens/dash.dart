import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/dashboard/presentation/widgets/userinfo.dart';
import 'package:task_manager/core/features/tasks/presentation/task_bloc/task_bloc.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/drawer.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/navigation_bar.dart';
import 'package:task_manager/core/permission/role.dart';

class DashBoardScreen extends StatefulWidget {
  DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          CircleAvatar(child: Center(child: Text("N"))),

          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none, color: Colors.lightBlue),
          ),
        ],
      ),

      drawer: DrawerHome(role: UserRole.admin),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Admin DashBoard",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: TextFormField(
                      controller: searchController,
                      onChanged: (value) {
                        // context.read<TaskBloc>().searchProducts(value);
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search Now',
                        filled: true,
                        fillColor: Colors.lightBlue.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "My Projects",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  TextButton(onPressed: () {}, child: Text("View All")),
                ],
              ),
              SizedBox(height: 10),
              GridView.builder(
                itemCount: 4,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1,
                  mainAxisExtent: 200,
                ),
                itemBuilder: (context, index) => Card(
                  shadowColor: Colors.blueGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.folder, color: Colors.lightBlue),
                            Text(
                              "website project",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10),
                        Text(
                          "Members 5",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),

                        Text(
                          "Delivery date: September 30",
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(height: 20),
                        LinearProgressIndicator(value: 0.6),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                child: BlocConsumer<TaskBloc, TaskState>(
                  builder: (BuildContext context, TaskState state) {
                    if (state is TaskLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is TaskLoaded) {
                      int index = 0;
                      final task = state.tasks;
                      return DataTable(
                        columns: <DataColumn>[
                          DataColumn(label: Expanded(child: Text("Task Name"))),
                          DataColumn(
                            label: Expanded(child: Text("Project Name")),
                          ),
                          DataColumn(label: Expanded(child: Text("Priority"))),
                          DataColumn(label: Expanded(child: Text("Due Date"))),
                          DataColumn(label: Expanded(child: Text("Status"))),
                        ],
                        rows: [
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text("Task ${task[index].title}")),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text("Task ${task[index].project_id}")),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text("Task ${task[index].priority}")),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text("Task ${task[index].due_date}")),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text("Task ${task[index].status}")),
                            ],
                          ),
                        ],
                      );
                    }
                    return Center(child: Text("No Tasks Yet"));
                  },
                  listener: (BuildContext context, TaskState state) {
                    if (state is TaskError) {
                      ScaffoldMessenger(
                        child: SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
