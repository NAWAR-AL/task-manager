class DashboardEntity {
  DataEntity? data;
  DashboardEntity({this.data});
}

class DataEntity {
  String? scope;
  int? total_projects;
  int? active_projects;
  int? total_tasks;
  int? todo;
  int? in_progress;
  int? review;
  int? done;
  int? high_priority;
  int? overdue;
  DataEntity({
    this.scope,
    this.total_projects,
    this.todo,
    this.total_tasks,
    this.overdue,
    this.review,
    this.active_projects,
    this.done,
    this.high_priority,
    this.in_progress,
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['scope'] = scope;
    data['total_projects'] = total_projects;
    data['active_projects'] = active_projects;
    data['total_tasks'] = total_tasks;
    data['todo'] = todo;
    data['done'] = done;
    data['in_progress'] = in_progress;
    data['review'] = review;
    data['high_priority'] = high_priority;
    data['overdue'] = overdue;
    return data;
  }
}

/// عنصر واحد في قسم (Recent Activity) بالداشبورد — مشتق من بيانات حقيقية
/// (آخر المستخدمين والمشاريع والمهام حسب تاريخ الإنشاء).
class RecentActivityEntity {
  /// 'user' | 'project' | 'task'
  final String type;
  final String title;
  final String subtitle;
  final DateTime time;
  const RecentActivityEntity({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.time,
  });
}
