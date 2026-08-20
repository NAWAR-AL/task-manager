import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart';
import 'core/features/auth/presentation/cubit/register_cubit.dart';
import 'core/features/auth/presentation/cubit/login_cubit.dart';
import 'core/features/auth/presentation/cubit/logout_cubit.dart';
import 'core/features/auth/presentation/pages/register_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegisterCubit>(
          create: (_) => sl<RegisterCubit>(),
        ),
        BlocProvider<LoginCubit>(
          create: (_) => sl<LoginCubit>(),
        ),
        BlocProvider<LogoutCubit>(
          create: (_) => sl<LogoutCubit>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RegisterPage(),
      ),
    );
  }
}