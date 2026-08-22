class ProjectEntity {
  int id;
  String name;
  String description;
  String status;
  int user_id;
  DateTime timestamps;

  ProjectEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.timestamps,
    required this.user_id,
  });
}
