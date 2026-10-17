import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/auth/domain/usecases/login_usecases.dart';
import 'package:task_manager/core/permission/role.dart';
import '../../domain/entities/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUsecase loginUsecase;

  LoginCubit(this.loginUsecase) : super(LoginInial());

  Future<void> login(Login login) async {
    emit(LoginLaoding());
    // print('starting login ');
    try {
      final token = await loginUsecase(login);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("auth_token", token);
      // print('token$token');
      // print('token ssaved');
      final roleString = await loginUsecase.getMyRole();
      // print('me successfully');
      // print('Role from Api is $roleString');
      final role = UserRole.values.firstWhere((r) => r.name == roleString);
      print('Role from cubit is ${role.name}');
      await prefs.setString('user_role', role.name);

      emit(LoginSuccess(role));
    } catch (e) {
      // print('login error $e');
      emit(LoginFailure(e.toString()));
    }
  }
}
