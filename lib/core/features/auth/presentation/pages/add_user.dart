import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:task_manager/core/features/app_widgets/app_widgets.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/auth/domain/entities/register.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_cubit.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/profile_state.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/register_cubit.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/register_state.dart';
import 'package:task_manager/core/features/auth/presentation/pages/user_profile_page.dart';
import 'package:task_manager/core/permission/role.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final password_confirmation = TextEditingController();
  final passwordController = TextEditingController();

  /// نوع الحساب الجديد (admin / developer / editor)
  String _selectedRole = 'developer';

  /// بيضل true من لحظة الضغط لحد ما يخلص تسجيل + تعيين الدور
  bool _submitting = false;

  static const List<String> _roles = ['admin', 'developer', 'editor'];

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    password_confirmation.dispose();
    super.dispose();
  }

  void _showSnack(String message, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  void _submit() {
    if (_submitting) return;

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirm = password_confirmation.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showSnack('Please fill in all fields', Colors.red[400]!);
      return;
    }
    if (!email.contains('@')) {
      _showSnack('Please enter a valid email', Colors.red[400]!);
      return;
    }
    if (password != confirm) {
      _showSnack('Passwords do not match', Colors.red[400]!);
      return;
    }

    setState(() => _submitting = true);
    context.read<RegisterCubit>().register(
      Register(name, email, password, confirm),
    );
  }

  /// endpoint الـ register ما بيرجع الـ id ولا بيقبل حقل role،
  /// فبعد النجاح بنشوف اليوزر الجديد بالإيميل وبندبّس له الدور
  /// عبر نفس updateUserRole المستخدم بصفحة تعديل الدور.
  Future<void> _assignRoleAndFinish() async {
    final messenger = ScaffoldMessenger.of(context);
    String? error;

    try {
      final profileCubit = context.read<ProfileCubit>();
      await profileCubit.fetchUsers();
      final state = profileCubit.state;

      if (state is UsersLoaded) {
        final email = emailController.text.trim().toLowerCase();
        final match = state.users.where(
          (u) => u.email.trim().toLowerCase() == email,
        );
        if (match.isNotEmpty) {
          await profileCubit.updateUserRole(match.first.id, _selectedRole);
          if (profileCubit.state is UserErorr) {
            error = (profileCubit.state as UserErorr).message;
          }
        } else {
          error = 'new user not found';
        }
      } else if (state is UserErorr) {
        error = state.message;
      }
    } catch (e) {
      error = e.toString();
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => UserProfilePage(role: UserRole.admin)),
    );

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        error == null
            ? SnackBar(
                content: Text(
                  'User created — role: ${ColorsApp.prettyRole(_selectedRole)}',
                ),
                backgroundColor: Colors.green[400],
              )
            : const SnackBar(
                content: Text(
                  'User created, but the role could not be set — '
                  'you can change it from the user page',
                ),
                backgroundColor: Colors.orange,
              ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        // Register Success → ندبّس الدور وبعدها نرجع لصفحة اليوزرز
        if (state is RegisterSuccess) {
          _assignRoleAndFinish();
        }

        // Register Failure
        if (state is RegisterFailure) {
          setState(() => _submitting = false);
          _showSnack(state.message, Colors.red[400]!);
        }
      },

      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Add New User'),
            actions: [LogoutButton()],
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Create New User Now",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Gap(20),

                    // --------------------------------
                    // Username
                    // --------------------------------
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Username",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const Gap(10),

                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,

                        labelText: "Username",

                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: ColorsApp.primary,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Colors.black87,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const Gap(20),

                    // --------------------------------
                    // Email
                    // --------------------------------
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const Gap(10),

                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,

                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,

                        labelText: "Email",

                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: ColorsApp.primary,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.black87,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    Gap(20),

                    // --------------------------------
                    // Password
                    // --------------------------------
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    Gap(10),

                    TextField(
                      controller: passwordController,
                      obscureText: true,

                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,

                        labelText: "Password",

                        prefixIcon: const Icon(
                          Icons.password,
                          color: ColorsApp.primary,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Colors.black87,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const Gap(10),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Confirm Password",

                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Gap(10),

                    TextField(
                      controller: password_confirmation,
                      obscureText: true,

                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,

                        labelText: "Confirm Password",

                        prefixIcon: const Icon(
                          Icons.password,
                          color: ColorsApp.primary,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Colors.black87,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const Gap(20),

                    // --------------------------------
                    // Role — نوع الحساب (admin / developer / editor)
                    // --------------------------------
                    AppDropdown<String>(
                      label: 'Role',
                      hint: 'Select the user role',
                      prefixIcon: Icons.shield_outlined,
                      value: _selectedRole,
                      items: _roles
                          .map(
                            (role) => DropdownMenuItem(
                              value: role,
                              child: Text(ColorsApp.prettyRole(role)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _selectedRole = value);
                      },
                    ),

                    const Gap(30),

                    // --------------------------------
                    // Sign Up Button
                    // --------------------------------
                    SizedBox(
                      width: 250,
                      height: 50,

                      child: ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.blue),

                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                        ),

                        onPressed: _submitting ? null : _submit,

                        child: _submitting
                            ? const SizedBox(
                                height: 30,
                                width: 30,

                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text("Create Now"),
                      ),
                    ),

                    const Gap(20),

                    // --------------------------------
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
