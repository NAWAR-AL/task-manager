class ProjectEntity {
  final int? id;
  final String name;
  final String description;
  final String status;
  final int? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProjectEntity({
    this.id,
    required this.name,
    required this.description,
    required this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });
}
