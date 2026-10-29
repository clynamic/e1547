import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

List<String> postSearchTerms(String? tags) =>
    splitQueryTerms((tags ?? '').split(RegExp(r'\s+')));

bool isOwnFavorites(String? tags, String? username) {
  final List<String> terms = postSearchTerms(tags);
  return terms.length == 1 &&
      terms.single.startsWith('fav:') &&
      isOwnFavoritesName(terms.single.substring('fav:'.length), username);
}

class PostSearchHeader extends StatelessWidget {
  const PostSearchHeader({super.key, required this.onChip, this.selected});

  final ValueChanged<int> onChip;
  final int? selected;

  @override
  Widget build(BuildContext context) {
    final Client client = context.watch<Client>();
    final PostParamsController params = context.watch<PostParamsController>();
    final PostFilter filter = context.watch<PostFilter>();
    final List<String> terms = postSearchTerms(params.value.tags);
    return QueryBuilder(
      query: client.tags.usePreview(
        names: terms
            .map(tagWithoutPrefix)
            .where((e) => !e.contains(':'))
            .toList(),
      ),
      builder: (context, state) {
        final Map<String, TagPreview> previews = {
          for (final TagPreview preview in state.data ?? const <TagPreview>[])
            preview.name: preview,
        };
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            MediaQuery.paddingOf(context).top + 20,
            16,
            14,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              PostSearchTitle(tags: params.value.tags),
              ListenableBuilder(
                listenable: filter,
                builder: (context, child) => Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final (int index, String term) in terms.indexed)
                      QueryChip(
                        term: term,
                        dense: true,
                        selected: index == selected,
                        preview: previews[tagWithoutPrefix(term)],
                        onTap: () => onChip(index),
                      ),
                    if (filter.denying && filter.blockedCount > 0)
                      HiddenChip(
                        count: filter.blockedCount,
                        onTap: () => showHiddenPostsSheet(context, filter),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PostSearchTitle extends StatelessWidget {
  const PostSearchTitle({super.key, required this.tags});

  final String? tags;

  @override
  Widget build(BuildContext context) {
    final Client client = context.watch<Client>();
    final List<String> terms = postSearchTerms(tags);
    Widget title(String text, [IconData? icon]) => Row(
      spacing: 10,
      children: [
        if (icon != null)
          Icon(icon, size: 26, color: Theme.of(context).colorScheme.primary),
        Flexible(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 28, height: 36 / 28),
          ),
        ),
      ],
    );
    if (terms.isEmpty) return title('All posts');
    if (isOwnFavorites(tags, client.identity.username)) {
      return title('Favorites');
    }
    final String query = TagMap(tags).toString();
    return QueryBuilder(
      query: client.follows.useAll(),
      builder: (context, state) {
        final Follow? follow = (state.data ?? const <Follow>[])
            .where((e) => TagMap(e.tags).toString() == query)
            .firstOrNull;
        if (follow == null) return title('Search');
        return title(follow.name, switch (follow.type) {
          FollowType.notify => Icons.notifications_active,
          FollowType.update => Icons.person_add,
          FollowType.bookmark => Icons.bookmark,
        });
      },
    );
  }
}

class PostTagPanel extends StatelessWidget {
  const PostTagPanel({
    super.key,
    required this.term,
    required this.onChange,
    required this.onRemove,
  });

  final String term;
  final ValueChanged<String> onChange;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String name = tagWithoutPrefix(term);
    final bool meta = name.contains(':');
    return QueryBuilder(
      query: context.watch<Client>().tags.usePreview(
        names: meta ? const [] : [name],
      ),
      builder: (context, state) {
        final TagPreview? preview = state.data?.firstOrNull;
        final TagCategory? category = tagCategoryOf(preview?.category);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 2),
              child: Row(
                spacing: 8,
                children: [
                  Container(
                    width: 2,
                    height: 14,
                    decoration: BoxDecoration(
                      color: meta
                          ? Colors.grey
                          : category?.colorFor(theme.brightness) ??
                                theme.colorScheme.onSurface.withValues(
                                  alpha: 0.38,
                                ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      metaWords(name) ?? name.replaceAll('_', ' '),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  if (preview?.postCount case final int count?
                      when category != null)
                    Text(
                      '${category.name[0].toUpperCase()}'
                      '${category.name.substring(1)} · '
                      '${NumberFormat.compact().format(count)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            QueryChipActions(
              term: term,
              onChange: onChange,
              onRemove: onRemove,
            ),
          ],
        );
      },
    );
  }
}
