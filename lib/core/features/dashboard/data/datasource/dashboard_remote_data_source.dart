import 'package:task_manager/core/features/dashboard/data/model/dashboard_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardModel> getstatistics();
}
