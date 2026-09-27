import 'package:adaptive_stat_card/adaptive_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_cubit.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_state.dart';
import 'package:task_manager/core/features/dashboard/presentation/bloc/dashboard_bloc.dart';

class DashScreen extends StatefulWidget {
  const DashScreen({super.key});

  @override
  State<DashScreen> createState() => _DashScreenState();
}

class _DashScreenState extends State<DashScreen> {
  @override
  void initState() {
    super.initState();

    context.read<ProfileCubit>().getDashboardusers();
    BlocProvider.of<DashboardBloc>(context, listen: false).add(GetStatistics());
  }

  // Future<void> _openCreateProject() async {
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => BlocProvider(
  //         create: (_) => sl<ProjectCubit>(),
  //         child: const CreateProjectPage(),
  //       ),
  //     ),
  //   );
  //   if (!mounted) return;
  //   context.read<ProjectCubit>().fetchProjects();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), actions: [
        
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is UsersLoaded) {
                  final usersInfo = state.users;
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: usersInfo.length,
                      itemBuilder: (context, index) {
                        final user = usersInfo[index];
                        return ListTile(
                          leading: Icon(Icons.person),
                          title: Text(user.email),
                          subtitle: Text(user.role),
                        );
                      },
                    ),
                  );
                }
                if (state is UserErorr) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
                return Center(child: Text('no User Data Available Now'));
              },
            ),
            BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                if (state is DashboardLoaded) {
                  final data = state.entity.data!;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Text('General Infromation'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            StatCard(
                              value: data.total_projects.toString(),
                              label: 'Total Projects',
                            ),
                            StatCard(
                              value: data.total_tasks.toString(),
                              label: 'Total Tasks',
                            ),
                          ],
                        ),

                        const Text(
                          'Tasks by Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(10),
                        GridView.count(
                          clipBehavior: Clip.hardEdge,
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1.5,
                          children: [
                            StatCard(
                              icon: Icon(Icons.tornado, color: Colors.orange),
                              value: data.todo.toString(),
                              label: 'Todo Tasks',
                            ),
                            StatCard(
                              value: data.in_progress.toString(),
                              label: 'In Progress Tasks',
                            ),
                            StatCard(
                              value: data.done.toString(),
                              label: 'Done Tasks',
                            ),
                            StatCard(
                              value: data.review.toString(),
                              label: 'Review Tasks',
                            ),
                          ],
                        ),
                        const Text(
                          'Priority Tasks',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 10,
                          childAspectRatio: 1.5,
                          children: [
                            StatCard(
                              value: data.overdue.toString(),
                              label: 'OverDue Projects',
                            ),

                            StatCard(
                              value: data.high_priority.toString(),
                              label: 'High Priority Tasks',
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return Center(child: Text('no data Available Now'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
