import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanger/core/features/tasks/presentation/task_bloc/task_bloc.dart';
import 'package:taskmanger/core/injection/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setServicesInjection();
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => gitIt<TaskBloc>())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("task mangement app")),
      drawer: Drawer(child: Column(children: [Text("data")])),
      body: Column(
        children: [
          Text("Hello, clean archtitcure", style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
