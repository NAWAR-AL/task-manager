import 'package:task_manager/core/features/tasks/domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  TaskModel({
    super.id,
    required super.title,
    required super.description,
    required super.project_id,
    super.created_by,
    super.assigned_users,
    required super.due_date,
    required super.priority,
    required super.status,
    super.created_at,
    super.updated_at,
  });
  //convert json to object
  factory TaskModel.fromJson(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      project_id: map['project_id'] ?? 0,
      created_by: map['created_by'],
      assigned_users:
          map['assigned_users'] != null && map['assigned_users'] is List
          ? (map['assigned_users'] as List).map((item) {
              if (item is Map<String, dynamic>) {
                return item['id'] as int;
              }
              return item as int;
            }).toList()
          : [],

      due_date: DateTime.parse(map['due_date']),
      created_at: DateTime.parse(map['created_at']),
      updated_at: DateTime.parse(map['updated_at']),
      priority: map['priority'] ?? 'low',
      status: map['status'] ?? 'todo',
    );
  }

  ///convert object to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'project_id': project_id,
      'assigned_users': assigned_users ?? [],
      'created_by': created_by,
      'due_date': due_date.toIso8601String(),
      'priority': priority,
      'status': status,
      'updated_at': updated_at,
      'created_at': created_at,
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
      created_at: entity.created_at,
      updated_at: entity.updated_at,
    );
  }
}
