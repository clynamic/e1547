import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

void prefetchCovers(Client client, Iterable<int?> ids) {
  final List<int> missing = ids
      .whereType<int>()
      .where((id) => client.posts.postCache.get(id) == null)
      .toList();
  if (missing.isNotEmpty) client.posts.useByIds(ids: missing).fetch();
}

class PostCover extends StatelessWidget {
  const PostCover({
    super.key,
    required this.id,
    this.size = PostImageSize.preview,
    this.adaptive = false,
  });

  final int? id;
  final PostImageSize size;
  final bool adaptive;

  static const double emptyRatio = 0.8;

  @override
  Widget build(BuildContext context) {
    final Widget empty = ColoredBox(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.06),
    );
    Widget shape(Widget child, double ratio) => adaptive
        ? AspectRatio(aspectRatio: ratio, child: child)
        : SizedBox.expand(child: child);
    final int? id = this.id;
    if (id == null) return shape(empty, emptyRatio);
    return QueryBuilder(
      query: context.watch<Client>().posts.useGet(id: id, vendored: true),
      builder: (context, state) {
        final Post? post = state.data;
        final FilterController<Post>? filter = context
            .watch<FilterController<Post>?>();
        if (post == null ||
            post.file == null ||
            (filter != null && !filter.filter(post))) {
          return shape(empty, emptyRatio);
        }
        return shape(
          PostImageWidget(
            post: post,
            size: size,
            fit: BoxFit.cover,
            showProgress: false,
            withLowRes: false,
          ),
          (post.width / post.height).clamp(0.6, 1.4),
        );
      },
    );
  }
}
