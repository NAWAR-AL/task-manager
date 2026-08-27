import 'package:task_manager/core/features/project_management/domain/entities/project.dart';

class ProjectModel extends Project {
  ProjectModel({
    required super.id,
    required super.name,
    required super.description,
    required super.status,
    required super.createdBy,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      status: json["status"],
      createdBy: json["createdBy"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
