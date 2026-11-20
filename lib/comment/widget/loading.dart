import 'package:e1547/client/client.dart';
import 'package:e1547/comment/comment.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class CommentLoadingPage extends StatelessWidget {
  const CommentLoadingPage(this.id, {super.key});

  final int id;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final query = client.comments.useGet(id: id);
    return QueryBuilder(
      query: query,
      builder: (context, state) => LoadingPage(
        isLoading: state.isLoading || state.isInitial,
        isError: state.isError,
        isEmpty: state.data == null,
        loadingBuilder: (context, child) => Scaffold(
          appBar: AppBar(
            leading: const CloseButton(),
            title: Text('Comment #$id'),
          ),
          body: child(context),
        ),
        skeleton: (context) =>
            PostCommentsPage(postId: const CommentGhost().postId),
        onError: const Text('Failed to load comment'),
        onRetry: query.invalidate,
        onEmpty: const Text('Comment not found'),
        child: (context) => PostCommentsPage(postId: state.data!.postId),
      ),
    );
  }
}
