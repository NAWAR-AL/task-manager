import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/app_widgets/app_widgets.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/auth/domain/entities/user.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_cubit.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_state.dart';
import 'package:task_manager/core/features/auth/presentation/pages/edit_user_role_page.dart';
import 'package:task_manager/core/features/auth/presentation/pages/user_details_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // آخر قائمة تم تحميلها حتى ما تظل القائمة عاللودينق عند أي حالة
  List<User>? _cachedUsers;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openUserDetails(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UserDetailsPage(userId: user.id)),
    );
  }

  void _openEditRole(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditUserRolePage(user: user)),
    );
  }

  List<User> _filteredUsers(List<User> users) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return users;
    return users
        .where(
          (user) =>
              user.name.toLowerCase().contains(query) ||
              user.email.toLowerCase().contains(query) ||
              user.role.toLowerCase().contains(query),
        )
        .toList();
  }

  Widget _buildUserRow(User user) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: () => _openUserDetails(user),
      child: Row(
        children: [
          InitialsAvatar(name: user.name, radius: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: ColorsApp.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                RoleChip(role: user.role),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Change role',
            onPressed: () => _openEditRole(user),
            icon: const Icon(Icons.manage_accounts_outlined),
            style: IconButton.styleFrom(
              backgroundColor: ColorsApp.primarySoft,
              foregroundColor: ColorsApp.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(List<User> users) {
    final filtered = _filteredUsers(users);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      children: [
        AppTextField(
          controller: _searchController,
          label: 'Search users',
          hint: 'Search by name, email or role',
          prefixIcon: Icons.search_rounded,
          onChanged: (value) => setState(() => _searchQuery = value),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            const AppSectionTitle(
              text: 'Team members',
              icon: Icons.people_outline,
            ),
            const Spacer(),
            Text(
              '${filtered.length} of ${users.length}',
              style: const TextStyle(
                fontSize: 12,
                color: ColorsApp.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          const EmptyState(
            icon: Icons.person_search_outlined,
            title: 'No users found',
            subtitle: 'Try a different name, email or role.',
          )
        else
          ...filtered.map(
            (user) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildUserRow(user),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users Management')),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is UsersLoaded) {
            _cachedUsers = state.users;
          }
          if (state is UserRoleUpdated) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('User role updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
          }
          if (state is UserErorr) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
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
          if (state is UserErorr) {
            return EmptyState(
              icon: Icons.cloud_off_outlined,
              title: 'Could not load users',
              subtitle: state.message,
            );
          }
          return const LoadingView();
        },
      ),
    );
  }
}