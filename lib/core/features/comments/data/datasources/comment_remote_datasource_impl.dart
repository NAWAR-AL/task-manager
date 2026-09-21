import 'package:task_manager/core/features/comments/data/datasources/comment_remote_datasource.dart';
import 'package:task_manager/core/features/comments/data/model/comment_model.dart';
import 'package:task_manager/core/network/api_client.dart';

class CommentRemoteDatasourceImpl extends CommentRemoteDatasource {
  final ApiClient apiClient;
  CommentRemoteDatasourceImpl(this.apiClient);

  @override
  Future<CommentModel> createComment(int taskId, CommentModel comment) async {
    final response = await apiClient.dio.post(
      'https://taskback.orbit-eng.net/api/tasks/$taskId/comments',
      data: {'content': comment.content},
    );

    final responseData = response.data['data'];

    return CommentModel.fromJson(Map<String, dynamic>.from(responseData));
  }

  // @override
  // Future<void> deleteComment(int commentId) {
  //
  //   throw UnimplementedError();
  // }

  // @override
  // Future<CommentModel> getComment(int commentId) {
  //
  //   throw UnimplementedError();
  // }

  @override
  Future<List<CommentModel>> getComments(int taskId) async {
    final response = await apiClient.dio.get(
      'https://taskback.orbit-eng.net/api/tasks/$taskId/comments',
    );

    final responseData = response.data['data'] ?? response.data;
    return (responseData as List)
        .map((json) => CommentModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  // @override
  // Future<CommentModel> updateComment(CommentModel comment) {

  //   throw UnimplementedError();
  // }
}
