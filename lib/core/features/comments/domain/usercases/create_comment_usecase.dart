import 'package:task_manager/core/features/comments/domain/entities/comment_entity.dart';
import 'package:task_manager/core/features/comments/domain/repositories/comment_repository.dart';

class CreatCommentUsecase {
  final CommentRepository repository;
  CreatCommentUsecase(this.repository);
  Future<CommentEntity> call(CommentEntity comment, int taskId) {
    if (comment.content.trim().isEmpty) {
      throw Exception("the title cantnot be empty");
    }

    return repository.createComment(comment, taskId);
  }
}
