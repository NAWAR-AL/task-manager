import 'package:task_manager/core/features/comments/domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  CommentModel({
    required super.content,
    super.id,
    super.created_at,
    super.task_id,
    super.updated_at,
    super.user_id,
  });
  factory CommentModel.fromJson(Map<String, dynamic> map) {
    return CommentModel(
      content: map['content'],
      id: map['id'],
      created_at: DateTime.parse(map['created_at']),
      task_id: map['task_id'],
      updated_at: DateTime.parse(map['updated_at']),
      user_id: map['user_id'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'content': content,
    if (task_id != null) 'task_id': task_id,
    };
    
  }

  factory CommentModel.fromEntity(CommentEntity comment) {
    return CommentModel(
      content: comment.content,
      id: comment.id,
      task_id: comment.task_id,
      created_at: comment.created_at,
      updated_at: comment.updated_at,
      user_id: comment.user_id,
    );
  }
}
