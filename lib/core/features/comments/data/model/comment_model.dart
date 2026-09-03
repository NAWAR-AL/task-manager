import 'package:task_manager/core/features/comments/domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  CommentModel({required super.authorName, required super.text, required super.timestamps});
}
