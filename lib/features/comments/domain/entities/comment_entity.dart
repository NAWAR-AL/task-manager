class CommentEntity {
  int? id;
  int? task_id;
  int? user_id;

  final String content;
  DateTime? created_at;
  DateTime? updated_at;
  CommentEntity({
    required this.content,
    this.created_at,
    this.id,
    this.task_id,
    this.updated_at,
    this.user_id,
  });
}
