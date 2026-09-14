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
                  Center(child: Text(project.name)),
                  Gap(20),
                  Text(project.description),
                  Gap(20),
                  Text(project.status),
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
