import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/features/app_widgets/app_widgets.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/auth/domain/entities/user.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_cubit.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_state.dart';
import 'package:task_manager/core/features/auth/presentation/pages/edit_user_role_page.dart';

class UserDetailsPage extends StatefulWidget {
  final int userId;
  const UserDetailsPage({super.key, required this.userId});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return DateFormat('dd MMM yyyy • hh:mm a').format(date);
  }

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchUser(widget.userId);
  }

  Widget _buildHeader(User user) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          InitialsAvatar(
            name: user.name,
            radius: 32,
            backgroundColor: ColorsApp.primarySoft,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: ColorsApp.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: const TextStyle(
                    fontSize: 13,
                    color: ColorsApp.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    RoleChip(role: user.role),
                    const SizedBox(width: 8),
                    if (user.email_verified_at != null)
                      const AppChip(
                        label: 'Verified',
                        color: ColorsApp.success,
                        icon: Icons.verified_outlined,
                      )
                    else
                      const AppChip(
                        label: 'Not verified',
                        color: ColorsApp.warning,
                        icon: Icons.error_outline,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(User user) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionTitle(text: 'Account', icon: Icons.badge_outlined),
          const SizedBox(height: 6),
          DetailRow(
            icon: Icons.tag,
            label: 'User ID',
            value: user.id.toString(),
          ),
          const Divider(),
          DetailRow(
            icon: Icons.person_outline,
            label: 'Full name',
            value: user.name,
          ),
          const Divider(),
          DetailRow(
            icon: Icons.alternate_email,
            label: 'Email',
            value: user.email,
          ),
          const Divider(),
          DetailRow(
            icon: Icons.shield_outlined,
            label: 'Role',
            value: ColorsApp.prettyRole(user.role),
          ),
          const Divider(),
          DetailRow(
            icon: Icons.calendar_month_outlined,
            label: 'Joined at',
            value: _formatDate(user.created_at),
          ),
          const Divider(),
          DetailRow(
            icon: Icons.update_rounded,
            label: 'Last updated',
            value: _formatDate(user.updated_at),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const LoadingView();
          }

          if (state is SingleUserLoaded) {
            final user = state.user;
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              children: [
                _buildHeader(user),
                const SizedBox(height: 16),
                _buildInfo(user),
                const SizedBox(height: 24),
                AppButton(
                  label: 'Change role',
                  icon: Icons.manage_accounts_outlined,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditUserRolePage(user: user),
                      ),
                    );
                  },
                ),
              ],
            );
          }

          if (state is UserErorr) {
            return EmptyState(
              icon: Icons.person_off_outlined,
              title: 'Could not load this user',
              subtitle: state.message,
            );
          }

          return const EmptyState(
            icon: Icons.person_outline,
            title: 'No user selected',
          );
        },
      ),
    );
  }
}