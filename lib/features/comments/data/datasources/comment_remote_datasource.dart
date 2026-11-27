import 'package:task_manager/features/comments/data/model/comment_model.dart';

abstract class CommentRemoteDatasource {
  // Future<void> deleteComment(int commentId);
  Future<CommentModel> createComment(int taskId, CommentModel comment);
  Future<List<CommentModel>> getComments(int taskId);
  // Future<CommentModel> getComment(int commentId);
  // Future<CommentModel> updateComment(CommentModel comment);
}
