import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/core/features/dashboard/domain/entity/dashboard_entity.dart';
import 'package:task_manager/core/features/dashboard/domain/usecase/dashboard_usecase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetstatisticsUseCase getstatisticsUseCase;
  DashboardBloc({required this.getstatisticsUseCase})
    : super(DashboardInitial()) {
    on<GetStatistics>((event, emit) async {
      emit(DashboardLoading());
      try {
        final statics = await getstatisticsUseCase();
        emit(DashboardLoaded(statics));
      } catch (e) {
        emit(DashboardError(e.toString()));
      }
    });
  }
}
