// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gap/gap.dart';
// import 'package:task_manager/core/features/auth/domain/entities/reset_password.dart';
// import 'package:task_manager/core/features/auth/presentation/cubit/forgot_password_cubit.dart';
// import 'package:task_manager/core/features/auth/presentation/cubit/forgot_password_state.dart';

// class ResetPasswordPage extends StatefulWidget {
//   final String email;

//   const ResetPasswordPage({super.key, required this.email});

//   @override
//   State<ResetPasswordPage> createState() => _ResetPasswordPageState();
// }

// class _ResetPasswordPageState extends State<ResetPasswordPage> {
//   late final emailController = TextEditingController(text: widget.email);
//   final tokenController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmController = TextEditingController();

//   @override
//   void dispose() {
//     emailController.dispose();
//     tokenController.dispose();
//     passwordController.dispose();
//     confirmController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Reset Password")),
//       body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
//         listener: (context, state) {
//           if (state is ResetPasswordSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: const Text(
//                   "Password reset successfully, please login",
//                 ),
//                 backgroundColor: Colors.green[400],
//               ),
//             );
//             // نرجع للمستخدم على صفحة الدخول
//             Navigator.popUntil(context, (route) => route.isFirst);
//           }
//           if (state is ResetPasswordFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red[400],
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           final isLoading = state is ResetPasswordLoading;
//           return Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   const Icon(
//                     Icons.password,
//                     size: 64,
//                     color: Colors.lightBlue,
//                   ),
//                   const Gap(16),
//                   const Text(
//                     "Set New Password",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const Gap(8),
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: const Color(0xffEAF3FF),
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     child: const Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Icon(
//                           Icons.info_outline,
//                           size: 20,
//                           color: Color(0xff1976D2),
//                         ),
//                         Gap(10),
//                         Expanded(
//                           child: Text(
//                             "Open the reset email we sent you, tap the "
//                             "link in it, and copy the token from the link "
//                             "address (the part after /reset-password/).",
//                             style: TextStyle(
//                               fontSize: 13,
//                               height: 1.4,
//                               color: Color(0xff34495E),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Gap(24),
//                   TextField(
//                     controller: emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       floatingLabelBehavior: FloatingLabelBehavior.never,
//                       labelText: "Email",
//                       prefixIcon: const Icon(Icons.email),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                     ),
//                   ),
//                    Gap(14),
//                   TextField(
//                     controller: tokenController,
//                     decoration: InputDecoration(
//                       floatingLabelBehavior: FloatingLabelBehavior.never,
//                       labelText: "Reset Token",
//                       hintText: "e.g. 8f3a2c1b5d9e4f6a",
//                       helperText: "From the link in your reset email",
//                       prefixIcon: const Icon(Icons.vpn_key),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                     ),
//                   ),
//                    Gap(14),
//                   TextField(
//                     controller: passwordController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       floatingLabelBehavior: FloatingLabelBehavior.never,
//                       labelText: "New Password",
//                       prefixIcon: const Icon(Icons.lock_outline),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                     ),
//                   ),
//                    Gap(14),
//                   TextField(
//                     controller: confirmController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       floatingLabelBehavior: FloatingLabelBehavior.never,
//                       labelText: "Confirm Password",
//                       prefixIcon:  Icon(Icons.lock),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                     ),
//                   ),
//                    Gap(24),
//                   SizedBox(
//                     height: 50,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         foregroundColor: Colors.white,
//                       ),
//                       onPressed: isLoading
//                           ? null
//                           : () {
//                               final params = ResetPassword(
//                                 token: tokenController.text.trim(),
//                                 email: emailController.text.trim(),
//                                 password: passwordController.text,
//                                 passwordConfirmation: confirmController.text,
//                               );
//                               context
//                                   .read<ForgotPasswordCubit>()
//                                   .resetPassword(params);
//                             },
//                       child: isLoading
//                           ?  SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                           :  Text("Reset Password"),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }