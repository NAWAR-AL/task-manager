import 'package:task_manager/core/features/tasks/domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  TaskModel({
    super.id,
    required super.title,
    required super.description,
    required super.project_id,
    super.created_by,
    required super.assigned_users,
    required super.due_date,
    required super.priority,
    required super.status,
  });
  //convert json to object
  factory TaskModel.fromJson(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      project_id: map['project_id'],
      created_by: map['created_by'],
      assigned_users: List<int>.from(map['assigned_users'] ?? []),
      due_date: DateTime.parse(map['due_date']),
      priority: map['priority'],
      status: map['status'],
    );
  }

  ///convert object to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'project_id': project_id,
      'assigned_users': assigned_users,
      'created_by': created_by,
      'due_date': due_date,
      'priority': priority,
      'status': status,
    };
  }

  // convert entity to model
  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      project_id: entity.project_id,
      created_by: entity.created_by,
      assigned_users: entity.assigned_users,
      due_date: entity.due_date,
      priority: entity.priority,
      status: entity.status,
    );
  }
}
