import 'package:task_manager/features/comments/domain/entities/comment_entity.dart';

abstract class CommentRepository {
  Future<CommentEntity> createComment(CommentEntity comment, int taskId);

  Future<List<CommentEntity>> getComments(int taskId);
}
