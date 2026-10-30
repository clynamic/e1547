import 'package:e1547/post/post.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

class PostSearchDock extends StatelessWidget {
  const PostSearchDock({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final PostParamsController? params = context.watch<PostParamsController?>();
    final PostFilter filter = context.watch<PostFilter>();
    final SelectionLayoutData<Post>? selection = SelectionLayout.maybeOf<Post>(
      context,
    );
    final bool selecting = selection != null && selection.selections.isNotEmpty;
    return NavBarDock(
      full: selecting,
      builder: selecting
          ? (_) => PostSelectionBar(selection: selection)
          : params != null && params.canSearch
          ? (_) => PostDock(
              params: params,
              filter: filter,
              onOpen: (transition) =>
                  showPostSearchSheet(context, transition: transition),
              onHidden: () => showHiddenPostsSheet(context, filter),
            )
          : null,
      child: child,
    );
  }
}

class PostDock extends StatelessWidget {
  const PostDock({
    super.key,
    required this.params,
    required this.filter,
    required this.onOpen,
    required this.onHidden,
  });

  final PostParamsController params;
  final PostFilter filter;
  final Future<void> Function(AnimationController? transition) onOpen;
  final VoidCallback onHidden;

  @override
  Widget build(BuildContext context) => SearchDock(
    onOpen: onOpen,
    child: ListenableBuilder(
      listenable: Listenable.merge([params, filter]),
      builder: (context, child) => Row(
        spacing: 4,
        children: [
          Flexible(child: QueryChipRow(query: params.value.tags ?? '')),
          if (filter.denying && filter.blockedCount > 0)
            HiddenChip(count: filter.blockedCount, onTap: onHidden),
        ],
      ),
    ),
  );
}

class HiddenChip extends StatelessWidget {
  const HiddenChip({super.key, required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color dim = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.5);
    return Tooltip(
      message: '$count hidden',
      child: Material(
        type: MaterialType.transparency,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.22),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 26,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: [
                  Icon(Icons.block, size: 14, color: dim),
                  Text('$count', style: TextStyle(fontSize: 13, color: dim)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchDock extends StatelessWidget {
  const SearchDock({super.key, required this.onOpen, required this.child});

  final Future<void> Function(AnimationController? transition) onOpen;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool left = Handedness.of(context) == Handedness.left;
    return DragToOpen(
      open: onOpen,
      child: InkWell(
        onTap: () => onOpen(null),
        child: Stack(
          children: [
            Row(
              textDirection: left ? TextDirection.rtl : TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: left
                        ? const EdgeInsets.fromLTRB(10, 8, 12, 8)
                        : const EdgeInsets.fromLTRB(12, 8, 10, 8),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: child,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 44,
                  margin: left
                      ? const EdgeInsets.fromLTRB(6, 6, 0, 6)
                      : const EdgeInsets.fromLTRB(0, 6, 6, 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.search, color: theme.colorScheme.onPrimary),
                ),
              ],
            ),
            Positioned(
              top: 4,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 32,
                  height: 3,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QueryChipRow extends StatelessWidget {
  const QueryChipRow({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<String> terms = query.split(RegExp(r'\s+'))
      ..removeWhere((e) => e.isEmpty);
    if (terms.isEmpty) {
      return Text(
        'Search',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      );
    }
    return TagPreviewBuilder(
      terms: terms,
      builder: (context, previews) {
        return ClipRect(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              spacing: 4,
              children: [
                for (final String term in terms)
                  QueryChip(
                    term: term,
                    dense: true,
                    preview: previews.of(term),
                    selected: false,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class QueryLine extends StatelessWidget {
  const QueryLine({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<String> tokens = query.split(RegExp(r'\s+'))
      ..removeWhere((e) => e.isEmpty);
    if (tokens.isEmpty) {
      return Text(
        'Search',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      );
    }
    return TagPreviewBuilder(
      terms: tokens,
      builder: (context, previews) => ClipRect(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            spacing: 12,
            children: [
              for (final String token in tokens)
                QueryToken(token, preview: previews.of(token)),
            ],
          ),
        ),
      ),
    );
  }
}

class QueryToken extends StatelessWidget {
  const QueryToken(this.token, {super.key, this.preview});

  final String token;
  final TagPreview? preview;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String prefix = switch (token[0]) {
      '-' || '~' => token[0],
      _ => '',
    };
    final String name = token.substring(prefix.length).replaceAll('_', ' ');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 2,
          height: 15,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: name.contains(':')
                ? Colors.grey
                : TagCategory.byId(
                        preview?.category,
                      )?.colorFor(theme.brightness) ??
                      theme.colorScheme.onSurface.withValues(alpha: 0.38),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              if (prefix.isNotEmpty)
                TextSpan(
                  text: prefix,
                  style: TextStyle(
                    color: prefix == '~'
                        ? Colors.orange.shade300
                        : Colors.red.shade300,
                  ),
                ),
              TextSpan(text: name),
            ],
          ),
          maxLines: 1,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
