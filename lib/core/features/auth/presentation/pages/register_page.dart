import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:task_manager/core/features/auth/domain/entities/register.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/register_cubit.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/register_state.dart';
import 'package:task_manager/core/features/auth/presentation/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                "User registered successfully",
              ),
              backgroundColor: Colors.green[400],
            ),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginPage(),
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
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Padding(
                padding: const EdgeInsets.all(30),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --------------------------------
                    // Title
                    // --------------------------------

                    const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Gap(40),

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
                      controller: userNameController,
                      decoration: InputDecoration(
                        floatingLabelBehavior:
                            FloatingLabelBehavior.never,

                        labelText: "Username",

                        prefixIcon: const Icon(
                          Icons.person_outline,
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
                        floatingLabelBehavior:
                            FloatingLabelBehavior.never,

                        labelText: "Email",

                        prefixIcon: const Icon(
                          Icons.email_outlined,
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
                    // Password
                    // --------------------------------

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const Gap(10),

                    TextField(
                      controller: passwordController,
                      obscureText: true,

                      decoration: InputDecoration(
                        floatingLabelBehavior:
                            FloatingLabelBehavior.never,

                        labelText: "Password",

                        prefixIcon: const Icon(
                          Icons.password,
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
                          backgroundColor: WidgetStatePropertyAll(
                            Colors.blue,
                          ),

                          foregroundColor: WidgetStatePropertyAll(
                            Colors.white,
                          ),
                        ),

                        onPressed: state is RegisterLoading
                            ? null
                            : () {
                                final user = Register(
                                  userNameController.text,
                                  emailController.text,
                                  passwordController.text,
                                );

                                context
                                    .read<RegisterCubit>()
                                    .register(user);
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
                            : const Text(
                                "Sign Up",
                              ),
                      ),
                    ),

                    const Gap(20),

                    // --------------------------------
                    // Go To Login
                    // --------------------------------

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginPage(),
                          ),
                        );
                      },

                      child: const Text(
                        "Already have an account? Login",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
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