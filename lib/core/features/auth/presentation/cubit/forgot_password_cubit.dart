import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/auth/domain/entities/reset_password.dart';
import 'package:task_manager/core/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:task_manager/core/features/auth/domain/usecases/reset_password_usecase.dart';

import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUsecase forgotPasswordUsecase;
  final ResetPasswordUsecase resetPasswordUsecase;

  ForgotPasswordCubit({
    required this.forgotPasswordUsecase,
    required this.resetPasswordUsecase,
  }) : super(ForgotPasswordInitial());

  Future<void> sendForgotEmail(String email) async {
    emit(ForgotPasswordLoading());
    try {
      await forgotPasswordUsecase(email);
      emit(ForgotPasswordSuccess(
        'Password reset link sent to your email',
      ));
    } catch (e) {
      emit(ForgotPasswordFailure(_message(e)));
    }
  }

  Future<void> resetPassword(ResetPassword params) async {
    emit(ResetPasswordLoading());
    try {
      await resetPasswordUsecase(params);
      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(ResetPasswordFailure(_message(e)));
    }
  }

  String _message(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      if (data is String && data.isNotEmpty) {
        return data;
      }
      return 'Connection error, please try again';
    }
    return e.toString();
  }
}