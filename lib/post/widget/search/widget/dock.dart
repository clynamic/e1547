import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

class PostSearchDock extends StatelessWidget {
  const PostSearchDock({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final PostParamsController params = context.watch<PostParamsController>();
    if (!params.canSearch) return child;
    final PostFilter filter = context.watch<PostFilter>();
    return NavBarDock(
      builder: (_) => PostDock(
        params: params,
        filter: filter,
        onOpen: () => showPostSearchSheet(context),
        onHidden: () => showHiddenPostsSheet(context, filter),
      ),
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
  final VoidCallback onOpen;
  final VoidCallback onHidden;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool left = Handedness.of(context) == Handedness.left;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragEnd: (details) {
        if ((details.primaryVelocity ?? 0) < 0) onOpen();
      },
      child: InkWell(
        onTap: onOpen,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                width: 32,
                height: 3,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: left
                    ? const EdgeInsets.fromLTRB(8, 4, 12, 8)
                    : const EdgeInsets.fromLTRB(12, 4, 8, 8),
                child: Row(
                  textDirection: left ? TextDirection.rtl : TextDirection.ltr,
                  spacing: 10,
                  children: [
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: ListenableBuilder(
                          listenable: Listenable.merge([params, filter]),
                          builder: (context, child) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5,
                            children: [
                              DockQuery(query: params.value.tags ?? ''),
                              if (filter.denying && filter.blockedCount > 0)
                                GestureDetector(
                                  onTap: onHidden,
                                  child: Text(
                                    '${filter.blockedCount} hidden',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox.square(
                      dimension: 40,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.search,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DockQuery extends StatelessWidget {
  const DockQuery({super.key, required this.query});

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
    final List<String> names = terms
        .map(tagWithoutPrefix)
        .where((e) => !e.contains(':'))
        .toList();
    return QueryBuilder(
      query: context.watch<Client>().tags.usePreview(names: names),
      builder: (context, state) {
        final Map<String, TagPreview> previews = {
          for (final TagPreview preview in state.data ?? const <TagPreview>[])
            preview.name: preview,
        };
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
                    preview: previews[tagWithoutPrefix(term)],
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
    return ClipRect(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          spacing: 10,
          children: [for (final String token in tokens) QueryToken(token)],
        ),
      ),
    );
  }
}

class QueryToken extends StatelessWidget {
  const QueryToken(this.token, {super.key});

  final String token;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String prefix = switch (token[0]) {
      '-' || '~' => token[0],
      _ => '',
    };
    final String name = token.substring(prefix.length).replaceAll('_', ' ');
    return Container(
      padding: const EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 2,
            color: name.contains(':')
                ? Colors.grey
                : theme.colorScheme.onSurface.withValues(alpha: 0.38),
          ),
        ),
      ),
      child: Text.rich(
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
        style: theme.textTheme.bodyLarge?.copyWith(fontSize: 15, height: 1.2),
      ),
    );
  }
}

class HiddenCount extends StatelessWidget {
  const HiddenCount({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Icon(Icons.block, size: 14, color: color),
        Text(
          '$count',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 13,
            color: color,
          ),
        ),
      ],
    );
  }
}
