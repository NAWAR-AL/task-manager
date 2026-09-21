import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/features/comments/presentation/comment_bloc/comment_bloc.dart';
import 'package:task_manager/core/features/tasks/presentation/widgets/comment_add.dart';

class CommentScreen extends StatefulWidget {
  final int taskId;
  const CommentScreen({super.key, required this.taskId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CommentBloc>().add(GetCommentsEvent(widget.taskId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Comments')),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: BlocBuilder<CommentBloc, CommentState>(
          builder: (context, state) {
           
            if (state is CommentsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CommentsLoaded) {
              final comments = state.comments;
             
              if (comments.isEmpty) {
                return Text('No Comments Yet');
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return Card(
                    elevation: 2,
                    color: getCardBackgoundColor(index),
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey),
                    ),
                    child: ListTile(
                      title: Text(comment.content),
                      subtitle: Text(comment.created_at.toString()),
                    ),
                  );
                },
              );
            }
            if (state is CommentError) {
              return Center(child: Text('Error ${state.message}'));
            }
            return Center(child: Text("Initial State"));
          },
        ),
      ),
    );
  }
}
