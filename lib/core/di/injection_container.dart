import 'package:get_it/get_it.dart';
import 'package:task_manager/core/di/project_injection.dart';
import 'package:task_manager/core/di/task_injection.dart';
import 'register_injection.dart';
import 'login_injection.dart';
import 'logout_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // initCore();
  initRegister();
  initLogin();
  logoutInjection();
  initTask();
  initProject();
}
