import 'package:task_manager/core/features/dashboard/data/datasource/dashboard_remote_data_source.dart';
import 'package:task_manager/core/features/dashboard/domain/entity/dashboard_entity.dart';
import 'package:task_manager/core/features/dashboard/domain/repository/dashboard_repository.dart';

class DashboardRepositoryImpl extends DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  DashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<DashboardEntity> getstatistics() async {
    return await remoteDataSource.getstatistics();
  }
}
