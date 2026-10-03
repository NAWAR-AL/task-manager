import 'package:task_manager/core/features/dashboard/domain/entity/dashboard_entity.dart';

abstract class DashboardRepository {
  Future<DashboardEntity> getstatistics();

  Future<List<RecentActivityEntity>> getRecentActivity();
}
