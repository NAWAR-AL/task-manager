import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/core/features/project_management/presentation/cubit/project_cubit.dart';
import 'package:task_manager/core/features/tasks/presentation/task_bloc/task_bloc.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/navigation_bar.dart';
import 'package:task_manager/core/permission/role.dart';
import 'core/di/injection_container.dart';
import 'core/features/auth/presentation/cubit/register_cubit.dart';
import 'core/features/auth/presentation/cubit/login_cubit.dart';
import 'core/features/auth/presentation/cubit/logout_cubit.dart';
import 'core/features/auth/presentation/pages/register_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegisterCubit>(create: (_) => sl<RegisterCubit>()),
        BlocProvider<LoginCubit>(create: (_) => sl<LoginCubit>()),
        BlocProvider<LogoutCubit>(create: (_) => sl<LogoutCubit>()),
        BlocProvider<TaskBloc>(create: (_) => sl<TaskBloc>()),
        BlocProvider<ProjectCubit>(create: (_) => sl<ProjectCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TaskBottomBar(role: UserRole.admin),
        // home: DashBoardScreen(),

        // TaskScreen()
      ),
    );
  }
}
