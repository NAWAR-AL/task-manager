import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/core/features/dashboard/domain/entity/dashboard_entity.dart';
import 'package:task_manager/core/features/dashboard/domain/usecase/dashboard_usecase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetstatisticsUseCase getstatisticsUseCase;
  final GetRecentActivityUseCase getRecentActivityUseCase;
  DashboardBloc({
    required this.getstatisticsUseCase,
    required this.getRecentActivityUseCase,
  }) : super(DashboardInitial()) {
    on<GetStatistics>((event, emit) async {
      emit(DashboardLoading());
      try {
        final statics = await getstatisticsUseCase();
        // أفضل مجهود: فشل جلب النشاطات لا يوقف الداشبورد كاملاً.
        var activity = const <RecentActivityEntity>[];
        try {
          activity = await getRecentActivityUseCase();
        } catch (_) {}
        emit(DashboardLoaded(statics, activity));
      } catch (e) {
        emit(DashboardError(e.toString()));
      }
    });
  }
}
