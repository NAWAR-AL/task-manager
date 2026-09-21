import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/comments/domain/entities/comment_entity.dart';
import 'package:task_manager/core/features/comments/domain/usercases/create_comment_usecase.dart';
import 'package:task_manager/core/features/comments/domain/usercases/get_comments_usecase.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final GetCommentsUsecase getcommentsUsecase;
  final CreatCommentUsecase creatCommentUsecase;
  CommentBloc({
    required this.getcommentsUsecase,
    required this.creatCommentUsecase,
  }) : super(CommentInitial()) {
    on<GetCommentsEvent>((event, emit) async {
      emit(CommentsLoading());
      try {
        final comments = await getcommentsUsecase(event.taskId);

        emit(CommentsLoaded(comments));
      } catch (e) {
        emit(CommentError(e.toString()));
      }
    });
    on<CreateCommentEvent>((event, emit) async {
      emit(CommentsLoading());
      try {
        await creatCommentUsecase(event.comment, event.taskId);
        emit(CommentsAdded());
        add(GetCommentsEvent(event.taskId));
      } catch (e) {
        emit(CommentError(e.toString()));
      }
    });
  }
}
