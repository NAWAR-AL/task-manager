import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/app_widgets/app_widgets.dart';
import 'package:task_manager/core/features/auth/domain/entities/user.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_cubit.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_state.dart';

class EditUserInfoPage extends StatefulWidget {
  final User updatedUser;

  const EditUserInfoPage({super.key, required this.updatedUser});

  @override
  State<EditUserInfoPage> createState() => _EditUserInfoPageState();
}

class _EditUserInfoPageState extends State<EditUserInfoPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.updatedUser.name;
    emailController.text = widget.updatedUser.email;

    context.read<ProfileCubit>().fetchUser(widget.updatedUser.id);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSaveChanges(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _saving = true);
    final Map<String, dynamic> updateInfo = {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      '_method': 'PATCH',
    };
    final newPassword = passwordController.text.trim();
    if (newPassword.isNotEmpty) {
      updateInfo['password'] = newPassword;
      updateInfo['password_confirmation'] = confirmPasswordController.text
          .trim();
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _saving = true);

    final updatedUser = User(
      id: widget.updatedUser.id,
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      role: widget.updatedUser.role,
      email_verified_at: widget.updatedUser.email_verified_at,
      created_at: widget.updatedUser.created_at,
      updated_at: widget.updatedUser.updated_at,
    );

    try {
      context.read<ProfileCubit>().updateUserprofile(
        userEntity: updatedUser,
        password: passwordController.text.trim().isEmpty
            ? null
            : passwordController.text.trim(),
        passwordConfrim: confirmPasswordController.text.trim().isEmpty
            ? null
            : confirmPasswordController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error:$e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User Role'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [LogoutButton()],
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is UserUpdated) {
            setState(() {
              _saving = false;
            });
          }
          if (state is UserErorr) {
            setState(() => _saving = false);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.fixed,
                ),
              );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 28),
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppSectionTitle(
                        text: 'User info',
                        icon: Icons.person_3_outlined,
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        controller: nameController,
                        label: 'User Name',
                        prefixIcon: Icons.title,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the user name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        controller: emailController,
                        label: 'email',
                        prefixIcon: Icons.email_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the user email';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      AppTextField(
                        obscureText: true,
                        controller: passwordController,
                        label: 'New Password (optional)',
                        prefixIcon: Icons.password_outlined,
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              value.length < 6) {
                            return 'password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        obscureText: true,
                        controller: confirmPasswordController,
                        label: 'Confrim Password',
                        prefixIcon: Icons.password_outlined,
                        validator: (value) {
                          if (passwordController.text.isNotEmpty &&
                              value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                AppButton(
                  label: 'Save Changes',
                  icon: Icons.check_rounded,
                  loading: _saving,
                  onPressed: () {
                    _handleSaveChanges(context);
                  },
                ),

                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close_rounded, size: 18),
                  label: Text('Cancel'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
