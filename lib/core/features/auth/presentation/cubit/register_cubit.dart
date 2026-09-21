import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/auth/domain/usecases/register_usecases.dart';
import '../../domain/entities/register.dart';
import 'register_state.dart';


class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUsecase registerUsecase;

  RegisterCubit(this.registerUsecase) : super(RegisterInial());

  Future<void> register(Register register) async {
    emit(RegisterLoading());

    try {
      await registerUsecase(register);
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}