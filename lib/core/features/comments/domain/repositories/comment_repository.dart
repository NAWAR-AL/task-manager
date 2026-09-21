import 'package:task_manager/core/features/comments/domain/entities/comment_entity.dart';

abstract class CommentRepository {
  Future<CommentEntity> createComment(CommentEntity comment, int taskId);
  // Future<void> deleteComment(int commentId);
  // Future<CommentEntity> updateComment(CommentEntity comment);
  // Future<CommentEntity> getComment(int commentId);
  Future<List<CommentEntity>> getComments(int taskId);
}
