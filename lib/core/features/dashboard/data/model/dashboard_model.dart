import 'package:task_manager/core/features/dashboard/domain/entity/dashboard_entity.dart';

class DashboardModel extends DashboardEntity {
  DashboardModel({super.data});
  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final targetJson = json.containsKey('data') ? json['data'] : json;
    return DashboardModel(
      data: targetJson != null
          ? DataModel.fromJson(Map<String, dynamic>.from(targetJson))
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (data != null) {
      map['data'] = (data as DataModel).toJson();
    }
    return map;
  }
}

class DataModel extends DataEntity {
  DataModel({
    super.scope,
    super.total_projects,
    super.todo,
    super.total_tasks,
    super.overdue,
    super.review,
    super.active_projects,
    super.done,
    super.high_priority,
    super.in_progress,
  });
  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      scope: json['scope'] ?? 'all_data',
      total_projects: json['total_projects'],
      todo: json['todo'],
      total_tasks: json['total_tasks'],
      overdue: json['overdue'],
      review: json['review'],
      active_projects: json['active_projects'],
      done: json['done'],
      high_priority: json['high_priority'],
      in_progress: json['in_progress'],
    );
  }
}
