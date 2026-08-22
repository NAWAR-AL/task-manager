import 'package:taskmanger/core/features/project_management/domain/entity/project_entity.dart';

class ProjectModel extends ProjectEntity {
  new({
    required super.id,
    required super.name,
    required super.description,
    required super.status,
    required super.timestamps,
    required super.user_id,
  });
  factory ProjectModel.fromJson(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      status: map['status'],
      timestamps: map['timestamps'],
      user_id: map['user_id'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'user_id': user_id,
      'timestamps': timestamps,
    };
  }
}
