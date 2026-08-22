import 'package:taskmanger/core/features/dashboard/domain/entity/comment_entity.dart';

class CommentModel extends CommentEntity {
  new({
    required super.content,
    required super.id,
    required super.task_id,
    required super.timestamps,
    required super.user_id,
  });
  factory CommentModel.fromJson(Map<String, dynamic> map) {
    return CommentModel(
      content: map['content'],
      id: map['id'],
      task_id: map['task_id'],
      timestamps: map['timestamps'],
      user_id: map['user_id'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'content': content,
      'timestamps': timestamps,
      'task_id': task_id,
    };
  }
}
