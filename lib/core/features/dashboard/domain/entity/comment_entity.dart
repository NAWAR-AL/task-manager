class CommentEntity {
  int id;
  int user_id;
  int task_id;
  String content;
  DateTime timestamps;
  CommentEntity({
    required this.content,
    required this.id,
    required this.task_id,
    required this.timestamps,
    required this.user_id,
  });
}
