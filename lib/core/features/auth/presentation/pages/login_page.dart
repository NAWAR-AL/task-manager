import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:task_manager/core/features/app_widgets/navigation_bar.dart';
import 'package:task_manager/core/features/auth/domain/entities/login.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/login_cubit.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/login_state.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/logout_cubit.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/logout_state.dart';
import 'package:task_manager/core/permission/role.dart';

import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Login Listener
        BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Login Successfully"),
                  backgroundColor: Colors.green[400],
                ),
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskBottomBar(
                    role: UserRole.admin,
                  ),
                ),
              );
            }

            if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.massage),
                  backgroundColor: Colors.red[400],
                ),
              );
            }
          },
        ),

        // Logout Listener
        BlocListener<LogoutCubit, LogoutState>(
          listener: (context, state) {
            if (state is LogoutSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Logout Successfully"),
                  backgroundColor: Colors.green[400],
                ),
              );
            }

            if (state is LogoutFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red[400],
                ),
              );
            }
          },
        ),
      ],

      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Login Page"),
            ),

            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),

                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // -------------------------
                      // Title
                      // -------------------------

                      const Text(
                        "LogIn",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Gap(50),

                      // -------------------------
                      // Email Label
                      // -------------------------

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

                      // -------------------------
                      // Email TextField
                      // -------------------------

                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,

                        decoration: InputDecoration(
                          floatingLabelBehavior:
                              FloatingLabelBehavior.never,

                          labelText: "Email",

                          prefixIcon: const Icon(
                            Icons.email,
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

                      // -------------------------
                      // Password Label
                      // -------------------------

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

                      // -------------------------
                      // Password TextField
                      // -------------------------

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

                      const Gap(20),

                      // -------------------------
                      // Login Button
                      // -------------------------

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

                          onPressed: state is LoginLaoding
                              ? null
                              : () {
                                  final login = Login(
                                    emailController.text,
                                    passwordController.text,
                                  );

                                  context
                                      .read<LoginCubit>()
                                      .login(login);
                                },

                          child: state is LoginLaoding
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,

                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "LogIn",
                                ),
                        ),
                      ),

                      const Gap(10),

                      // -------------------------
                      // Register
                      // -------------------------

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },

                        child: const Text(
                          "Don't have an account? Sign Up",

                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const Gap(10),

                      // -------------------------
                      // Logout Button
                      // -------------------------

                      SizedBox(
                        width: 100,
                        height: 40,

                        child: ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(
                                255,
                                243,
                                112,
                                103,
                              ),
                            ),

                            foregroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                          ),

                          onPressed: () {
                            context
                                .read<LogoutCubit>()
                                .logout();
                          },

                          child: const Text(
                            "Logout",
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
      ),
    );
  }
}