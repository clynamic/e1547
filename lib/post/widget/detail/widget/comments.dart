import 'package:e1547/client/client.dart';
import 'package:e1547/comment/comment.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

const int commentPreviewCount = 5;

String commentPreviewText(String body) => body
    .replaceAll(RegExp(r'\[quote\][\s\S]*?\[/quote\]'), '')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();

void openPostComments(BuildContext context, Post post) =>
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PostCommentsPage(postId: post.id),
      ),
    );

class PostCommentsLine extends StatelessWidget {
  const PostCommentsLine({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    if (post.commentCount <= 0) return const SizedBox.shrink();
    final Client client = context.watch<Client>();
    return FilterControllerProvider<CommentFilter, Comment>(
      create: (_) => CommentFilter(client),
      keys: (_) => [client],
      child: Builder(
        builder: (context) {
          final CommentFilter filter = context.watch<CommentFilter>();
          return QueryBuilder(
            query: client.comments.usePage(
              query: {
                ...CommentParams(
                  postId: post.id,
                  groupBy: CommentGroupBy.comment,
                ).toQuery(),
                'limit': '$commentPreviewCount',
              },
            ),
            builder: (context, state) {
              final Comment? comment = [
                for (final int id in state.data?.pages.firstOrNull ?? const [])
                  ?client.comments.commentCache.get(id),
              ].where(filter.filter).firstOrNull;
              return PostSectionLine(
                label: 'Comments',
                count: post.commentCount,
                summary: comment == null
                    ? ''
                    : [
                        comment.creatorName,
                        commentPreviewText(comment.body),
                        DateFormatting.age(comment.createdAt),
                      ].join(' · '),
                icon: Icons.chevron_right,
                onTap: () => openPostComments(context, post),
              );
            },
          );
        },
      ),
    );
  }
}
