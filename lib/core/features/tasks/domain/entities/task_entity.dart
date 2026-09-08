class TaskEntity {
  int? id;
  String title;
  String description;
  int project_id;
  int? created_by;
  List<int> assigned_to;
  String status;
  String priority;
  DateTime due_date;
  DateTime? timestamps;
  TaskEntity({
    this.id,
    required this.title,
    required this.description,
    required this.project_id,
    this.created_by,
    required this.assigned_to,
    required this.due_date,
    required this.priority,
    required this.status,
    this.timestamps,
  });
}
