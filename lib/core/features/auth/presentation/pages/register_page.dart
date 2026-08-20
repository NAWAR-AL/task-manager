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
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("User registered successfully"),
              backgroundColor: Colors.green[400],
            ),
          );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        }

        if (state is RegisterFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          // appBar: AppBar(title: Text("Sign Up")),
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(6),
                    Text(
                      "Sign up to continue shopping.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                    Gap(85),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("UserName"),
                    ),
                    TextField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        prefixIcon: Icon(Icons.person),
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

                        labelText: "Username",
                      ),
                    ),

                    Gap(20),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Email"),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        prefixIcon: Icon(Icons.email_outlined),
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
                        labelText: "Email",
                      ),
                    ),

                    Gap(20),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Password"),
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        prefixIcon: Icon(Icons.password),

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
                        labelText: "Password",
                      ),
                    ),

                    Gap(30),

                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.blue),
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                        ),
                        onPressed: state is RegisterLoading
                            ? null
                            : () {
                                final user = Register(
                                  userNameController.text,
                                  emailController.text,
                                  passwordController.text,
                                );

                                context.read<RegisterCubit>().register(user);
                              },
                        child: state is RegisterLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text("Sign Up"),
                      ),
                    ),
                    Gap(20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                        );
                      },
                      child: Text(
                        "Already have an account? Login",
                        style: TextStyle(color: Colors.black),
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
