import 'package:flutter/material.dart';
import 'package:task_manager/core/features/auth/data/models/login_model.dart';
import 'package:task_manager/core/permission/role.dart';

class UserInfo extends StatelessWidget {
  final LoginModel user;
  final UserRole role;
  UserInfo({super.key, required this.role, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          child: Text(
            user.username.isNotEmpty ? user.username.toUpperCase() : role.name,
          ),
        ),
        Text(role.name, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}



class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key});

  @override
  Widget build(BuildContext context) {
    return  GridView.builder(
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
                  elevation: 2,
                  borderOnForeground: true,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.deepPurpleAccent,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadiusGeometry.circular(12),
                  ),

                  shadowColor: Colors.blueGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xffdce7f9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.folder_outlined,

                                color: Colors.lightBlue,
                              ),
                            ),
                            Text(
                              "website project",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10),
                        Text(
                          " 5",
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
              );
  }
}