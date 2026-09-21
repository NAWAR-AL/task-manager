import 'package:task_manager/core/features/comments/domain/entities/comment_entity.dart';
import 'package:task_manager/core/features/comments/domain/repositories/comment_repository.dart';

class GetCommentsUsecase {
  final CommentRepository repository;
  GetCommentsUsecase(this.repository);
  Future<List<CommentEntity>> call(int taskId) {
    return repository.getComments(taskId);
  }
}
