import 'package:dio/dio.dart';
import 'package:task_manager/core/features/dashboard/data/datasource/dashboard_remote_data_source.dart';
import 'package:task_manager/core/features/dashboard/data/model/dashboard_model.dart';
import 'package:task_manager/core/features/dashboard/domain/entity/dashboard_entity.dart';
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

  /// قسم (Recent Activity): يجمع آخر المستخدمين والمشاريع والمهام من
  /// البيانات الحقيقية ويرتبهم بالأحدث (أقصى 6 عناصر).
  @override
  Future<List<RecentActivityEntity>> getRecentActivity() async {
    try {
      final results = await Future.wait([
        apiClient.dio.get('/users'),
        apiClient.dio.get('/projects'),
        apiClient.dio.get('/tasks'),
      ]);

      final items = <RecentActivityEntity>[];

      // آخر المستخدمين المسجلين
      for (final u in _toList(results[0])) {
        final time = _parseDate(u['created_at']);
        if (time == null) continue;
        items.add(
          RecentActivityEntity(
            type: 'user',
            title: 'New user registered',
            subtitle: '${u['name'] ?? ''} ${u['email'] ?? ''}'.trim(),
            time: time,
          ),
        );
      }

      // آخر المشاريع المضافة
      for (final p in _toList(results[1])) {
        final time = _parseDate(p['created_at']);
        if (time == null) continue;
        items.add(
          RecentActivityEntity(
            type: 'project',
            title: 'Project created',
            subtitle: p['name']?.toString() ?? '',
            time: time,
          ),
        );
      }

      // آخر المهام
      for (final t in _toList(results[2])) {
        final time = _parseDate(t['created_at']);
        if (time == null) continue;
        items.add(
          RecentActivityEntity(
            type: 'task',
            title: _taskStatusLabel(t['status']?.toString() ?? ''),
            subtitle: t['title']?.toString() ?? '',
            time: time,
          ),
        );
      }

      items.sort((a, b) => b.time.compareTo(a.time));
      return items.take(6).toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw NewtworkException();
      }
      throw ServerException();
    }
  }

  List<Map<String, dynamic>> _toList(Response<dynamic> response) {
    final dynamic raw = response.data['data'] ?? response.data;
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  String _taskStatusLabel(String status) {
    switch (status) {
      case 'done':
        return 'Task completed';
      case 'in_progress':
        return 'Task started';
      case 'review':
        return 'Task in review';
      case 'todo':
        return 'Task scheduled';
      default:
        return 'Task created';
    }
  }
}

class NewtworkException implements Exception {}

class ServerException implements Exception {}