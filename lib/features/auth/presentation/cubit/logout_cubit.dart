import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/network/api_error.dart';

import '../../domain/usecases/logout_usecase.dart';
import 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase logoutUseCase;

  LogoutCubit(this.logoutUseCase) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());

    try {
      await logoutUseCase();

      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutFailure(readableApiError(e)));
    }
  }
}