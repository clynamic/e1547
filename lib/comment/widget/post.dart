import 'package:e1547/client/client.dart';
import 'package:e1547/comment/comment.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class PostCommentsPage extends StatelessWidget {
  const PostCommentsPage({super.key, required this.postId});

  final int postId;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return FilterControllerProvider(
      create: (_) => CommentFilter(client),
      keys: (_) => [client],
      child: ListenableProvider(
        create: (_) => CommentParams()
          ..postId = postId
          ..groupBy = CommentGroupBy.comment
          ..order = CommentOrder.oldest,
        builder: (context, _) => AdaptiveScaffold(
          appBar: DefaultAppBar(
            title: Text('#$postId comments'),
            actions: const [ContextDrawerButton()],
          ),
          floatingActionButton: client.hasLogin
              ? CommentCreateFab(postId: postId)
              : null,
          endDrawer: const CommentListDrawer(),
          body: const CommentList(),
        ),
      ),
    );
  }
}
