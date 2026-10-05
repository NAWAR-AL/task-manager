import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/auth/domain/entities/user.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_cubit.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_state.dart';
import 'package:task_manager/core/features/auth/presentation/pages/user_details_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // آخر قائمة تم تحميلها حتى ما تظل القائمة عاللودينق عند أي حالة

  List<User>? _cachedUsers;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchUsers();
  }

  void _openUserDetails(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UserDetailsPage(userId: user.id)),
    );
  }

  Widget _buildUsersList(List<User> users) {
    if (users.isEmpty) {
      return const Center(child: Text('No users found'));
    }
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final color =
            ColorsApp.projectColors[index % ColorsApp.projectColors.length];

        return Padding(
          padding: const EdgeInsets.all(5),
          child: Center(
            child: SizedBox(
              height: 90,
              width: 350,
              child: Card(
                color: color,
                child: ListTile(
                  onTap: () {
                    _openUserDetails(user);
                  },
                  leading: const Icon(
                    Icons.person_outline,
                    color: Colors.lightBlue,
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: _RoleBadge(role: user.role),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users Management'), centerTitle: true),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is UsersLoaded) {
            _cachedUsers = state.users;
          }
          if (state is UserCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('User created successfully'),
                backgroundColor: Colors.green[400],
              ),
            );
          }
          if (state is UserErorr) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red[400],
              ),
            );
          }
        },
        builder: (context, state) {
          // إذا كانت القائمة محمّلة من قبل، نعرضها دائماً بدل اللودينق
          if (_cachedUsers != null) {
            return _buildUsersList(_cachedUsers!);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;
  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    final isAdmin = role == 'admin';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isAdmin ? Colors.redAccent : Colors.blueAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        role,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}


