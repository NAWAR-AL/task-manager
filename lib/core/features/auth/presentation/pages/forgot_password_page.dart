import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
// import 'package:task_manager/core/di/injection_container.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:task_manager/core/features/auth/presentation/cubit/forgot_password_state.dart';
// import 'package:task_manager/core/features/auth/presentation/pages/reset_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // void _openResetPage(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => BlocProvider(
  //         create: (_) => sl<ForgotPasswordCubit>(),
  //         child: ResetPasswordPage(email: emailController.text.trim()),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text("Forgot Password")),
      body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green[400],
              ),
            );
            // _openResetPage(context);
          }
          if (state is ForgotPasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red[400],
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ForgotPasswordLoading;
          return Center(
            child: SingleChildScrollView(
              padding:  EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   Icon(
                    Icons.lock_reset,
                    size: 64,
                    color: Colors.lightBlue,
                  ),
                   Gap(16),
                   Text(
                    "Forgot Password?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   Gap(8),
                   Text(
                    "Enter your email and we'll send you a link "
                    "to reset your password.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                   Gap(28),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: "Email",
                      prefixIcon:  Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                   Gap(24),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              final email = emailController.text.trim();
                              if (email.isEmpty) return;
                              context
                                  .read<ForgotPasswordCubit>()
                                  .sendForgotEmail(email);
                            },
                      child: isLoading
                          ?  SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          :  Text("Send Reset Link"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}