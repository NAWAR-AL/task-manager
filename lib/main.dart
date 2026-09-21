import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:task_manager/core/features/app_widgets/navigation_bar.dart';

import 'package:task_manager/core/features/auth/presentation/cubit/profile_cubit.dart';
import 'package:task_manager/core/features/auth/presentation/pages/register_page.dart';
import 'package:task_manager/core/features/comments/presentation/comment_bloc/comment_bloc.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/project_cubit.dart';
import 'package:task_manager/core/features/tasks/presentation/task_bloc/task_bloc.dart';

import 'package:task_manager/core/permission/role.dart';

import 'core/di/injection_container.dart';
import 'core/features/auth/presentation/cubit/register_cubit.dart';
import 'core/features/auth/presentation/cubit/login_cubit.dart';
import 'core/features/auth/presentation/cubit/logout_cubit.dart';
// import 'package:task_manager/core/features/dashboard/presentation/screens/dash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await init();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("auth_token");

  final isLoggedIn = token != null && token.isNotEmpty;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegisterCubit>(create: (_) => sl<RegisterCubit>()),
        BlocProvider<LoginCubit>(create: (_) => sl<LoginCubit>()),
        BlocProvider<LogoutCubit>(create: (_) => sl<LogoutCubit>()),
        BlocProvider<TaskBloc>(create: (_) => sl<TaskBloc>()),
        BlocProvider<ProjectCubit>(create: (_) => sl<ProjectCubit>()),
        BlocProvider<ProfileCubit>(create: (_) => sl<ProfileCubit>()),

        BlocProvider<CommentBloc>(create: (_) => sl<CommentBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,


        home: isLoggedIn
            ? const TaskBottomBar(role: UserRole.admin)
            : const RegisterPage(),
      ),
    );
  }
}
