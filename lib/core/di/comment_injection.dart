import 'package:task_manager/core/di/injection_container.dart';
import 'package:task_manager/core/features/comments/data/datasources/comment_remote_datasource.dart';
import 'package:task_manager/core/features/comments/data/datasources/comment_remote_datasource_impl.dart';
import 'package:task_manager/core/features/comments/data/repository/comment_repository_impl.dart';
import 'package:task_manager/core/features/comments/domain/repositories/comment_repository.dart';
import 'package:task_manager/core/features/comments/domain/usercases/create_comment_usecase.dart';
import 'package:task_manager/core/features/comments/domain/usercases/get_comments_usecase.dart';
import 'package:task_manager/core/features/comments/presentation/comment_bloc/comment_bloc.dart';

Future<void> initComment() async {
  sl.registerLazySingleton<CommentRemoteDatasource>(
    () => CommentRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => CreatCommentUsecase(sl()));
  sl.registerLazySingleton(() => GetCommentsUsecase(sl()));

  sl.registerLazySingleton(
    () => CommentBloc(getcommentsUsecase: sl(), creatCommentUsecase: sl()),
  );
}
