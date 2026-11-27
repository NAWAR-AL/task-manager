

import 'package:task_manager/features/project_management/domain/entities/project.dart';

class ProjectModel extends ProjectEntity {
  ProjectModel({
    super.id,
    required super.name,
    required super.description,
    required super.status,
    super.createdAt,
    super.createdBy,
    super.updatedAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      createdAt: json['createdAt'],
      createdBy: json['createdBy'],
      updatedAt: json['updatedAt'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'description': description,
      'createdBy': createdBy,
    };
  }
}
