import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../cubit/projects_state.dart';
import '../cubit/project_cubit.dart';

class ProjectDetailsPage extends StatefulWidget {
  final int? projectId;
  const ProjectDetailsPage({super.key, required this.projectId});

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProjectCubit>().getProjectDetails(widget.projectId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Project Details")),
      body: BlocBuilder<ProjectCubit, ProjectsState>(
        builder: (context, state) {
          if (state is ProjectLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is GetProjectDetailesLoaded) {
            final project = state.project;
            return SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 300,
                          height: 200,
                          child: Text(project.name),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                        ),
                        Gap(10),
                        Container(
                          width: 300,
                          height:200,
                          child: Text(project.description),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                        ),
                        Gap(10),
                        Container(
                          width: 300,
                          height: 200,
                          child: Text(project.status),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 15,
                                offset:  Offset(0, 5),
                              ),
                            ],
                          ),
                        ),


                      ],
                    ),
                  ),
                  Gap(20),
                  
                  Gap(20),
                  // Text(project.status),
                ],
              ),
            );
          }
          if (state is ProjectError) {
            return Center(child: Text(state.message));
          }
          return SizedBox();
        },
      ),
    );
  }
}
