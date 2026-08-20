import 'package:get_it/get_it.dart';

import 'register_injection.dart';
import 'login_injection.dart';
import 'core_injection.dart';
import 'logout_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await initCore();

  initRegister();
  initLogin();
  logoutInjection();
}