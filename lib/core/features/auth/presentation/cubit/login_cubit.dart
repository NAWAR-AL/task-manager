import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/auth/domain/usecases/login_usecases.dart';
import '../../domain/entities/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_state.dart';


class LoginCubit extends Cubit<LoginState> {
  final LoginUsecase loginUsecase;

  LoginCubit(this.loginUsecase) : super(LoginInial());

  Future<void> login(Login login) async {
    emit(LoginLaoding());

    try {
      final token = await loginUsecase(login);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token);

      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}