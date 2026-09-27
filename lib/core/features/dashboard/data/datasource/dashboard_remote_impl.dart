import 'package:dio/dio.dart';
import 'package:task_manager/core/features/dashboard/data/datasource/dashboard_remote_data_source.dart';
import 'package:task_manager/core/features/dashboard/data/model/dashboard_model.dart';
import 'package:task_manager/core/network/api_client.dart';

class DashboardRemoteImpl extends DashboardRemoteDataSource {
  final ApiClient apiClient;
  DashboardRemoteImpl(this.apiClient);
  @override
  Future<DashboardModel> getstatistics() async {
    try {
      final response = await apiClient.dio.get('/dashboard/stats');
      // return response.data;

      final responseData = response.data['data'] ?? response.data;
      return DashboardModel.fromJson(Map<String, dynamic>.from(responseData));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw NewtworkException();
      }
      throw ServerException();
    }
  }
}

class NewtworkException implements Exception {}

class ServerException implements Exception {}
