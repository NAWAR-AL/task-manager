import 'package:task_manager/core/features/comments/data/datasources/comment_remote_datasource.dart';
import 'package:task_manager/core/features/comments/data/model/comment_model.dart';
import 'package:task_manager/core/features/comments/domain/entities/comment_entity.dart';
import 'package:task_manager/core/features/comments/domain/repositories/comment_repository.dart';

class CommentRepositoryImpl extends CommentRepository {
  final CommentRemoteDatasource remoteDatasource;
  CommentRepositoryImpl(this.remoteDatasource);
  @override
  // Future<CommentEntity> createComment(int taskId, String content) async {
  //   final commentModel = CommentModel.fromEntity(taskId, content);
  //   final result = await remoteDatasource.createComment(commentModel);
  //   return result;
  // }
  @override
  Future<CommentEntity> createComment(CommentEntity comment, int taskId) async {
    final commentModel = CommentModel.fromEntity(comment);
    final result = await remoteDatasource.createComment(taskId, commentModel);
    return result;
  }

  // @override
  // Future<void> deleteComment(int commentId) async {
  //   return await remoteDatasource.deleteComment(commentId);
  // }

  // @override
  // Future<CommentEntity> getComment(int commentId) async {
  //   return await remoteDatasource.getComment(commentId);
  // }

  @override
  Future<List<CommentEntity>> getComments(int taskId) async {
    return await remoteDatasource.getComments(taskId);
  }

  // @override
  // Future<CommentEntity> updateComment(CommentEntity comment) async {
  //   final commentModel = CommentModel.fromEntity(comment);
  //   return await remoteDatasource.updateComment(commentModel);
  // }
}
