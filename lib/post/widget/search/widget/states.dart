import 'package:dio/dio.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

PagedChildBuilderDelegate<Post> postPagedChildBuilderDelegate({
  required ItemWidgetBuilder<Post> itemBuilder,
  required PagingState<int, Post> state,
  required VoidCallback fetchNextPage,
  Widget skeleton = const PostGridSkeleton(),
}) {
  return PagedChildBuilderDelegate<Post>(
    itemBuilder: itemBuilder,
    firstPageProgressIndicatorBuilder: (context) => skeleton,
    firstPageErrorIndicatorBuilder: (context) =>
        PostResultsFailure(error: state.error, onRetry: fetchNextPage),
    noItemsFoundIndicatorBuilder: (context) => const PostResultsEmpty(),
    newPageProgressIndicatorBuilder: (context) =>
        const LoadMoreFooter(state: LoadMoreState.loading, note: HiddenSoFar()),
    newPageErrorIndicatorBuilder: (context) => LoadMoreFooter(
      state: LoadMoreState.failed,
      label: 'Page ${(state.keys?.lastOrNull ?? 0) + 1} did not load',
      onRetry: fetchNextPage,
    ),
    noMoreItemsIndicatorBuilder: (context) =>
        const LoadMoreFooter(state: LoadMoreState.end, label: 'No more posts'),
  );
}

class PostGridSkeleton extends StatelessWidget {
  const PostGridSkeleton({super.key});

  static List<double> masonry(List<double> ratios, double width, double fill) {
    final List<double> heights = [];
    double total = 0;
    while (total < fill) {
      final double height = width * ratios[heights.length % ratios.length];
      heights.add(height);
      total += height;
    }
    return heights;
  }

  static const List<List<double>> ratios = [
    [1.25, 1.1, 1.15, 1.3],
    [1.0, 1.35, 1.05, 1.1],
  ];

  static Color color(ThemeData theme) =>
      theme.colorScheme.onSurface.withValues(alpha: 0.05);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TileLayoutData? layout = TileLayout.maybeOf(context);
    final int columns = layout?.crossAxisCount ?? 2;
    final EdgeInsetsGeometry margin =
        theme.cardTheme.margin ?? const EdgeInsets.all(4);
    final double screen = MediaQuery.sizeOf(context).height;
    Widget tile(double height) => Padding(
      padding: margin,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color(theme),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
    return SizedBox(
      height: screen,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth / columns;
          final EdgeInsets inset = margin.resolve(Directionality.of(context));
          final double inner = width - inset.horizontal;
          if (layout?.stagger != GridQuilt.vertical) {
            final double height =
                width * (layout?.tileHeightFactor ?? 1) - inset.vertical;
            return ClipRect(
              child: OverflowBox(
                alignment: Alignment.topCenter,
                maxHeight: double.infinity,
                child: Column(
                  children: [
                    for (
                      int row = 0;
                      row * (height + inset.vertical) < screen;
                      row++
                    )
                      Row(
                        children: [
                          for (int column = 0; column < columns; column++)
                            Expanded(child: tile(height)),
                        ],
                      ),
                  ],
                ),
              ),
            );
          }
          return ClipRect(
            child: OverflowBox(
              alignment: Alignment.topCenter,
              maxHeight: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int column = 0; column < columns; column++)
                    Expanded(
                      child: Column(
                        children: [
                          for (final double height in masonry(
                            ratios[column % ratios.length],
                            inner,
                            screen,
                          ))
                            tile(height),
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

class PostFeedSkeleton extends StatelessWidget {
  const PostFeedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = PostGridSkeleton.color(Theme.of(context));
    final double screen = MediaQuery.sizeOf(context).height;
    return SizedBox(
      height: screen,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double image = (constraints.maxWidth - 16) * 0.9;
          return ClipRect(
            child: OverflowBox(
              alignment: Alignment.topCenter,
              maxHeight: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int item = 0; item * image < screen; item++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: image,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            width: 120,
                            height: 12,
                            margin: const EdgeInsets.fromLTRB(16, 13, 16, 7),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
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

class ResultsMessage extends StatelessWidget {
  const ResultsMessage({
    super.key,
    required this.title,
    this.icon,
    this.body,
    this.details = const [],
    this.action,
  });

  final Widget? icon;
  final String title;
  final String? body;
  final List<Widget> details;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 14,
        children: [
          ?icon,
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          if (body case final body?)
            Text(
              body,
              style: TextStyle(
                fontSize: 14,
                height: 20 / 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
          ...details,
          ?action,
        ],
      ),
    );
  }
}

class ResultsButton extends StatelessWidget {
  const ResultsButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.filled = false,
  });

  final String label;
  final IconData? icon;
  final bool filled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color accent = theme.colorScheme.primary;
    return Material(
      color: filled ? accent : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: filled ? BorderSide.none : BorderSide(color: accent),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          height: 44,
          child: Padding(
            padding: EdgeInsets.fromLTRB(icon == null ? 16 : 12, 0, 16, 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                if (icon case final icon?)
                  Icon(
                    icon,
                    size: 18,
                    color: filled ? theme.colorScheme.onPrimary : accent,
                  ),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: filled ? theme.colorScheme.onPrimary : accent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String hostWords(BuildContext context) =>
    Uri.tryParse(context.read<Client>().identity.host)?.host ?? 'The server';

bool isConnectionError(Object? error) =>
    error is DioException &&
    error.response == null &&
    error.type != DioExceptionType.cancel;

class PostResultsFailure extends StatelessWidget {
  const PostResultsFailure({super.key, required this.error, this.onRetry});

  final Object? error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool offline = isConnectionError(error);
    final String host = hostWords(context);
    return ResultsMessage(
      icon: Icon(
        offline ? Icons.cloud_off : Icons.error_outline,
        size: 28,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      ),
      title: offline ? 'No connection' : 'Did not load',
      body: offline ? '$host did not answer.' : '$host answered with an error.',
      action: onRetry == null
          ? null
          : ResultsButton(
              label: 'Retry',
              icon: Icons.refresh,
              filled: true,
              onPressed: onRetry!,
            ),
    );
  }
}

class PostResultsEmpty extends StatelessWidget {
  const PostResultsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final PostFilter? filter = context.watch<PostFilter?>();
    if (filter != null &&
        filter.denying &&
        filter.tracked.isNotEmpty &&
        filter.tracked.every((post) => !filter.filter(post))) {
      return PostResultsHidden(filter: filter);
    }
    final PostParamsController? params = context.watch<PostParamsController?>();
    final List<String> terms = TagMap(params?.value.tags).tags;
    return ResultsMessage(
      title: 'No posts',
      action: params == null || !params.canSearch || terms.isEmpty
          ? null
          : ResultsButton(
              label: 'Remove ${terms.last}',
              icon: Icons.close,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PostsPage(
                    params: PostParams(
                      tags: terms.sublist(0, terms.length - 1).join(' '),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class PostResultsHidden extends StatelessWidget {
  const PostResultsHidden({super.key, required this.filter});

  final PostFilter filter;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<MapEntry<String, int>> lines =
        filter.matchCountsByEntry.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    final int hidden = filter.blockedCount;
    final BorderSide line = BorderSide(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
    );
    return ResultsMessage(
      icon: Icon(Icons.block, size: 28, color: Colors.red.shade300),
      title: '$hidden posts hidden',
      body: 'Your blacklist hides the posts on this page.',
      details: [
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
              ),
            ),
          ),
          child: Column(
            children: [
              for (final MapEntry(key: entry, value: count) in lines)
                Container(
                  height: 48,
                  decoration: BoxDecoration(border: Border(bottom: line)),
                  child: Row(
                    spacing: 10,
                    children: [
                      SizedBox(
                        width: 28,
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.55,
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: QueryChipRow(query: entry)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
      action: ResultsButton(
        label: 'Show $hidden posts',
        onPressed: () => filter.denying = false,
      ),
    );
  }
}

class HiddenSoFar extends StatelessWidget {
  const HiddenSoFar({super.key});

  @override
  Widget build(BuildContext context) {
    final PostFilter? filter = context.watch<PostFilter?>();
    if (filter == null || !filter.denying || filter.blockedCount == 0) {
      return const SizedBox.shrink();
    }
    final Color dim = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.5);
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 5,
      children: [
        Icon(Icons.block, size: 14, color: dim),
        Text(
          '${filter.blockedCount} hidden so far',
          style: TextStyle(fontSize: 13, color: dim),
        ),
      ],
    );
  }
}

class RefreshUnchangedNote extends StatelessWidget {
  const RefreshUnchangedNote({super.key});

  @override
  Widget build(BuildContext context) => Text(
    'Up to date',
    style: TextStyle(
      fontSize: 14,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
    ),
  );
}

class RefreshFailedNote extends StatelessWidget {
  const RefreshFailedNote({super.key, required this.error, this.onRetry});

  final Object? error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final String host = hostWords(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        Flexible(
          child: Text(
            isConnectionError(error)
                ? '$host did not answer.'
                : '$host answered with an error.',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
        if (onRetry case final onRetry?) RetryButton(onPressed: onRetry),
      ],
    );
  }
}
