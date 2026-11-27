part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object> get props => [];
}

class GetCommentsEvent extends CommentEvent {
  final int taskId;
  const GetCommentsEvent(this.taskId);
  @override
  List<Object> get props => [taskId];
}

class CreateCommentEvent extends CommentEvent {
  final int taskId;
  final CommentEntity comment;
  const CreateCommentEvent(this.taskId, this.comment);
  @override
  List<Object> get props => [taskId, comment];
}
