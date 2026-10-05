import 'package:task_manager/core/features/dashboard/domain/entity/dashboard_entity.dart';
import 'package:task_manager/core/features/dashboard/domain/repository/dashboard_repository.dart';

class GetstatisticsUseCase {
  final DashboardRepository repository;
  GetstatisticsUseCase(this.repository);
  Future<DashboardEntity> call() async {
    return await repository.getstatistics();
  }
}

class GetRecentActivityUseCase {
  final DashboardRepository repository;
  GetRecentActivityUseCase(this.repository);
  Future<List<RecentActivityEntity>> call() async {
    return await repository.getRecentActivity();
  }
}
