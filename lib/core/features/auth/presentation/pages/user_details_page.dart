import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/details_widget.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class UserDetailsPage extends StatefulWidget {
  final int userId;
  const UserDetailsPage({super.key, required this.userId});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchUser(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('User Details'), centerTitle: true),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SingleUserLoaded) {
            final user = state.user;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: buildDetailRow(
                      icon: Icons.person_outline,
                      title: 'Name: ',
                      value: user.name,
                    ),
                  ),
                  Card(
                    child: buildDetailRow(
                      icon: Icons.email_outlined,
                      title: 'Email: ',
                      value: user.email,
                    ),
                  ),
                  Card(
                    child: buildDetailRow(
                      icon: Icons.badge_outlined,
                      title: 'Role: ',
                      value: user.role,
                    ),
                  ),
                  Card(
                    child: buildDetailRow(
                      icon: Icons.date_range,
                      title: 'Created at: ',
                      value: user.created_at != null
                          ? user.created_at!
                                .toLocal()
                                .toString()
                                .split(' ')
                                .first
                          : '-',
                    ),
                  ),
                  Card(
                    child: buildDetailRow(
                      icon: Icons.verified_outlined,
                      title: 'Verified: ',
                      value: user.email_verified_at != null ? 'Yes' : 'No',
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is UserErorr) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
