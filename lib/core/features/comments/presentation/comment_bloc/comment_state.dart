part of 'comment_bloc.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

class CommentInitial extends CommentState {}

class CommentCreate extends CommentState {
  final int taskId;
  final CommentEntity comment;
  CommentCreate(this.comment, this.taskId);
  @override
  List<Object> get props => [taskId, comment];
}

class CommentsLoaded extends CommentState {
  final List<CommentEntity> comments;
  CommentsLoaded(this.comments);
  @override
  List<Object> get props => [comments];
}

class CommentsLoading extends CommentState {}

class CommentsAdded extends CommentState {}

class CommentError extends CommentState {
  final String message;
  const CommentError(this.message);
  @override
  List<Object> get props => [message];
}
