import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:task_manager/core/features/app_widgets/app_widgets.dart';
import 'package:task_manager/core/features/app_widgets/colors.dart';
import 'package:task_manager/core/features/auth/domain/entities/register.dart';
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
  final passwordController = TextEditingController();
  final password_confirmation = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        // Register Success
        if (state is RegisterSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => UserProfilePage(role: UserRole.admin),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("User registered successfully"),
              backgroundColor: Colors.green[400],
            ),
          );
        }

        // Register Failure
        if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red[400],
            ),
          );
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

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Confrim Password",

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

                        labelText: "Confrim Password",

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

                        onPressed: state is RegisterLoading
                            ? null
                            : () {
                                final user = Register(
                                  nameController.text,
                                  emailController.text,
                                  passwordController.text,
                                  password_confirmation.text,
                                );

                                context.read<RegisterCubit>().register(user);
                              },

                        child: state is RegisterLoading
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
