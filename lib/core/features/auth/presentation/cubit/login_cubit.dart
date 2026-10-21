import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/auth/domain/usecases/login_usecases.dart';
import 'package:task_manager/core/network/api_error.dart';
import 'package:task_manager/core/permission/role.dart';
import 'package:task_manager/core/storage/password_overrides.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/login.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUsecase loginUsecase;

  LoginCubit(this.loginUsecase) : super(LoginInial());

  Future<void> login(Login login) async {
    emit(LoginLaoding());
    // print('starting login ');
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = login.email.trim();

      // إذا المستخدم غيّر كلمة مروره لوكل (المحفوظة 'local')،
      // بنبعت للسيرفر النسخة الأصلية ('server') حتى يقبل الدخول
      // بالكلمة الجديدة — لحد ما يضيف الباك-إند endpoint تغيير الباسورد.
      var passwordToSend = login.password;
      final overrides = PasswordOverrides.read(prefs);
      final entry = overrides[email];
      if (entry != null &&
          entry['local'] == login.password &&
          entry['local'] != entry['server']) {
        passwordToSend = entry['server']!;
      }

      final token = await loginUsecase(Login(email, passwordToSend));
      await prefs.setString('auth_token', token);
      // print('token$token');
      // print('token ssaved');
      final roleString = await loginUsecase.getMyRole();
      // print('me successfully');
      // print('Role from Api is $roleString');
      final role = UserRole.values.firstWhere((r) => r.name == roleString);
      print('Role from cubit is ${role.name}');
      await prefs.setString('user_role', role.name);
      await prefs.setString('user_email', email);

      // نحفظ كلمة المرور الحالية لهاد الإيميل:
      // 'local' = يلي كتبها المستخدم، 'server' = يلي راحت للسيرفر فعلياً
      overrides[email] = {
        'local': login.password,
        'server': passwordToSend,
      };
      await PasswordOverrides.write(prefs, overrides);

      emit(LoginSuccess(role));
    } catch (e) {
      // print('login error $e');
      emit(LoginFailure(readableApiError(e)));
    }
  }
}
