import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUsecase getProfileUsecase;

  ProfileCubit({required this.getProfileUsecase}) : super(UserInial());

  Future<void> fetchProfile() async {
    emit(UserLoading());

    try {
      final profile = await getProfileUsecase();
      emit(UserLoaded(profile));
    } catch (e) {
      emit(UserErorr(e.toString()));
    }
  }
}
