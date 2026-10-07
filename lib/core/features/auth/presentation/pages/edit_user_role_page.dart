import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:task_manager/core/features/app_widgets/app_widgets.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/auth/domain/entities/user.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_cubit.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_state.dart';

class EditUserRolePage extends StatefulWidget {
  final User user;

  const EditUserRolePage({super.key, required this.user});

  @override
  State<EditUserRolePage> createState() => _EditUserRolePageState();
}

class _EditUserRolePageState extends State<EditUserRolePage> {
 
  static const _roles = ['admin', 'developer', 'editor'];

  late String _selectedRole;
  bool _saving = false;

  static const Map<String, String> _roleDescriptions = {
    'admin': 'Full access — manages users, roles, projects and tasks',
    'developer': 'Works on the tasks assigned to him',
    'editor': 'Reviews and updates the content of tasks',
  };

  static const Map<String, IconData> _roleIcons = {
    'admin': Icons.admin_panel_settings_outlined,
    'developer': Icons.code_outlined,
    'editor': Icons.edit_note_outlined,
  };

  @override
  void initState() {
    super.initState();
    _selectedRole = _roles.contains(widget.user.role)
        ? widget.user.role
        : 'developer';
  }

  Widget _buildRoleOption(String role) {
    final selected = _selectedRole == role;
    final color = ColorsApp.roleColor(role);

    return Padding(
      padding:  EdgeInsets.only(bottom: 12),
      child: Material(
        color: ColorsApp.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.card),
          onTap: () => setState(() => _selectedRole = role),
          child: Container(
            padding:  EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(
                color: selected ? color : ColorsApp.divider,
                width: selected ? 1.6 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(_roleIcons[role], color: color, size: 22),
                ),
                Gap(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ColorsApp.prettyRole(role),
                        style:  TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: ColorsApp.textPrimary,
                        ),
                      ),
                      Gap(3),
                      Text(
                        _roleDescriptions[role] ?? '',
                        style:  TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: ColorsApp.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(10),
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected ? color : ColorsApp.textMuted,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Edit User Role'),
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is UserRoleUpdated) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                 SnackBar(
                  content: Text('User role updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            Navigator.pop(context);
          }
          if (state is UserErorr) {
            setState(() => _saving = false);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        builder: (context, state) {
          return ListView(
            padding:  EdgeInsets.fromLTRB(20, 16, 20, 28),
            children: [
              // بطاقة بيانات المستخدم
              AppCard(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    InitialsAvatar(
                      name: widget.user.name,
                      radius: 26,
                      backgroundColor: ColorsApp.roleColor(widget.user.role)
                          .withValues(alpha: 0.12),
                      foregroundColor:
                          ColorsApp.roleColor(widget.user.role),
                    ),
                    Gap(14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.name,
                            style:  TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: ColorsApp.textPrimary,
                            ),
                          ),
                          Gap(3),
                          Text(
                            widget.user.email,
                            style: TextStyle(
                              fontSize: 13,
                              color: ColorsApp.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RoleChip(role: widget.user.role),
                  ],
                ),
              ),

              Gap(24),

               AppSectionTitle(
                text: 'Choose a new role',
                icon: Icons.manage_accounts_outlined,
              ),

              Gap(14),

              // خيارات الأدوار
              ..._roles.map(_buildRoleOption),

              Gap(12),

              AppButton(
                label: 'Save Changes',
                icon: Icons.check_rounded,
                loading: _saving,
                onPressed: () {
                  setState(() => _saving = true);
                  context
                      .read<ProfileCubit>()
                      .updateUserRole(widget.user.id, _selectedRole);
                },
              ),
             Gap(12),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon:  Icon(Icons.close_rounded, size: 18),
                label: Text('Cancel'),
              ),
            ],
          );
        },
      ),
    );
  }
}
