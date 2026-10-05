import 'package:task_manager/core/features/dashboard/data/model/dashboard_model.dart';
import 'package:task_manager/core/features/dashboard/domain/entity/dashboard_entity.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardModel> getstatistics();

  Future<List<RecentActivityEntity>> getRecentActivity();
}
