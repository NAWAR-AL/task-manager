import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/tasks/presentation/task_bloc/task_bloc.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/drawer.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/navigation_bar.dart';

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
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none, color: Colors.lightBlue),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: CircleAvatar(child: Text("Admin")),
          ),
        ],
      ),
      bottomNavigationBar: TaskBottomBar(),
      drawer: DrawerHome(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Admin DashBoard"),
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
                  fillColor: Colors.lightBlue,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
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
            Expanded(
              child: GridView.builder(
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) => Card(
                  shadowColor: Colors.blueGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
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
                          "project members",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text("5 Memeber", style: TextStyle(fontSize: 14)),
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
            ),
            SizedBox(height: 20),
            Card(
              child: Column(
                children: [
                  Text(
                    "project members",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  ListTile(title: Text("data")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
