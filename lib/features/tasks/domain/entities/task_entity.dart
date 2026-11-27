class TaskEntity {
  int? id;
  String title;
  String description;
  int project_id;
  int? created_by;
  List<int>? assigned_users;
  String status;
  String priority;
  DateTime due_date;
  DateTime? created_at;
  DateTime? updated_at;

  TaskEntity({
    this.id,
    required this.title,
    required this.description,
    required this.project_id,
    this.created_by,
    this.assigned_users,
    required this.due_date,
    required this.priority,
    required this.status,
    this.created_at,
    this.updated_at,
  });
}
