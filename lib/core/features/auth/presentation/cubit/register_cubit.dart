import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/auth/domain/usecases/register_usecases.dart';
import 'package:task_manager/core/network/api_error.dart';
import 'package:task_manager/core/storage/password_overrides.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/register.dart';
import 'register_state.dart';


class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUsecase registerUsecase;

  RegisterCubit(this.registerUsecase) : super(RegisterInial());

  Future<void> register(Register register) async {
    emit(RegisterLoading());

    try {
      await registerUsecase(register);

      // نحفظ كلمة المرور من وقت إنشاء الحساب (بتساوي القيمة الأصلية
      // بالسيرفر) حتى تشتغل بمقارنة صفحة تغيير كلمة المرور
      final prefs = await SharedPreferences.getInstance();
      final email = register.email.trim();
      final overrides = PasswordOverrides.read(prefs);
      overrides[email] = {
        'local': register.password,
        'server': register.password,
      };
      await PasswordOverrides.write(prefs, overrides);

      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(readableApiError(e)));
    }
  }
}