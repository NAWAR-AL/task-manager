import 'package:taskmanger/core/features/tasks/domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.project_id,
    required super.created_by,
    required super.assigned_to,
    required super.due_date,
    required super.priority,
    required super.status,
    required super.timestamps,
  });
  //convert json to object
  factory TaskModel.fromJson(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      project_id: map['project_id'],
      created_by: map['created_by'],
      assigned_to: map['assigned_to'],
      due_date: map['due_date'],
      priority: map['priority'],
      status: map['status'],
      timestamps: map['timestamps'],
    );
  }

  ///convert object to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'project_id': project_id,
      'assigned_to': assigned_to,
      'created_by': created_by,
      'due_date': due_date,
      'priority': priority,
      'status': status,
      'timestamps': timestamps,
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
      assigned_to: entity.assigned_to,
      due_date: entity.due_date,
      priority: entity.priority,
      status: entity.status,
      timestamps: entity.timestamps,
    );
  }
}
