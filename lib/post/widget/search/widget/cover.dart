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

class CoverRow extends StatelessWidget {
  const CoverRow({
    super.key,
    required this.cover,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  final int? cover;
  final String title;
  final Widget subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 52),
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
            ),
          ),
        ),
        child: Row(
          spacing: 12,
          children: [
            SizedBox(
              width: 36,
              height: 44,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: PostCover(id: cover),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  DefaultTextStyle.merge(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    child: subtitle,
                  ),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

int coverCardColumns(BuildContext context) =>
    (TileLayout.of(context).crossAxisCount * 0.5).round().clamp(2, 8);

class CoverCardSkeleton extends StatelessWidget {
  const CoverCardSkeleton({super.key, this.coverHeight});

  final double? coverHeight;

  @override
  Widget build(BuildContext context) {
    final Color color = PostGridSkeleton.color(Theme.of(context));
    final int columns = coverCardColumns(context);
    final double screen = MediaQuery.sizeOf(context).height;
    Widget line(double fontSize, double widthFactor) => Stack(
      alignment: Alignment.centerLeft,
      children: [
        Text(' ', style: TextStyle(fontSize: fontSize)),
        FractionallySizedBox(
          widthFactor: widthFactor,
          child: Container(
            height: fontSize * 0.75,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
    Widget card(double cover) => Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Container(
            height: cover,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [line(14, 0.8), line(12, 0.5)],
          ),
        ],
      ),
    );
    return SizedBox(
      height: screen,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width =
              (constraints.maxWidth - 8 * (columns - 1)) / columns;
          return ClipRect(
            child: OverflowBox(
              alignment: Alignment.topCenter,
              maxHeight: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  for (int column = 0; column < columns; column++)
                    Expanded(
                      child: Column(
                        children: [
                          for (final double cover
                              in coverHeight != null
                                  ? List.filled(
                                      (screen / coverHeight!).ceil(),
                                      coverHeight!,
                                    )
                                  : PostGridSkeleton.masonry(
                                      PostGridSkeleton.ratios[column %
                                          PostGridSkeleton.ratios.length],
                                      width,
                                      screen,
                                    ))
                            card(cover),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
