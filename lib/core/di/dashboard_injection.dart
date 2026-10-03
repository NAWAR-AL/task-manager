import 'package:task_manager/core/di/injection_container.dart';
import 'package:task_manager/core/features/dashboard/data/datasource/dashboard_remote_data_source.dart';
import 'package:task_manager/core/features/dashboard/data/datasource/dashboard_remote_impl.dart';
import 'package:task_manager/core/features/dashboard/data/repository/dashboard_repository_impl.dart';
import 'package:task_manager/core/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:task_manager/core/features/dashboard/domain/usecase/dashboard_usecase.dart';
import 'package:task_manager/core/features/dashboard/presentation/bloc/dashboard_bloc.dart';

Future initDashboard() async {
  sl.registerLazySingleton<DashboardBloc>(
    () => DashboardBloc(
      getstatisticsUseCase: sl(),
      getRecentActivityUseCase: sl(),
    ),
  );
  sl.registerLazySingleton<GetstatisticsUseCase>(
    () => GetstatisticsUseCase(sl()),
  );
  sl.registerLazySingleton<GetRecentActivityUseCase>(
    () => GetRecentActivityUseCase(sl()),
  );
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteImpl(sl()),
  );
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(sl()),
  );
}
