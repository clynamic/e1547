import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Map<String, String> ratingWords = {
  's': 'Safe',
  'q': 'Questionable',
  'e': 'Explicit',
};

class PostSearchSuggestions extends StatefulWidget {
  const PostSearchSuggestions({
    super.key,
    required this.typed,
    required this.onPick,
  });

  final String typed;
  final ValueSetter<String> onPick;

  @override
  State<PostSearchSuggestions> createState() => _PostSearchSuggestionsState();
}

class _PostSearchSuggestionsState extends State<PostSearchSuggestions> {
  List<Tag>? shownTags;

  @override
  Widget build(BuildContext context) {
    final String typed = widget.typed;
    final ValueSetter<String> onPick = widget.onPick;
    final Client client = context.watch<Client>();
    final String prefix = typed.startsWith('-') || typed.startsWith('~')
        ? typed[0]
        : '';
    final String search = typed.substring(prefix.length).toLowerCase();
    if (search.startsWith('rating:')) {
      final String value = search.substring('rating:'.length);
      return SuggestionList(
        children: [
          for (final MapEntry(key: key, value: word) in ratingWords.entries)
            if (key.startsWith(value) || word.toLowerCase().startsWith(value))
              SuggestionRow(
                label: '${prefix}rating:$key',
                meta: word,
                stripe: Colors.grey,
                onTap: () => onPick('${prefix}rating:$key'),
              ),
        ],
      );
    }
    return QueryBuilder(
      query: client.tags.useAutocomplete(search: search),
      builder: (context, tags) => QueryBuilder(
        query: client.histories.useRecentSearches(type: HistoryType.posts),
        builder: (context, history) => QueryBuilder(
          query: client.follows.useAll(),
          builder: (context, follows) {
            if (tags.data != null || tags.isError) shownTags = tags.data;
            final Set<String> searches = {};
            final List<Widget> recent = [];
            for (final History entry in history.data ?? const <History>[]) {
              final String? tags = postSearchTags(entry);
              if (tags == null || !tags.contains(search)) continue;
              if (!searches.add(tags)) continue;
              recent.add(
                SuggestionRow(
                  label: tags,
                  meta: 'Recent',
                  icon: Icons.history,
                  onTap: () => onPick(tags),
                ),
              );
            }
            final List<Widget> saved = [
              for (final Follow follow in follows.data ?? const <Follow>[])
                if (follow.tags.contains(search))
                  SuggestionRow(
                    label: follow.tags,
                    meta: 'Saved',
                    icon: Icons.bookmark,
                    onTap: () => onPick(follow.tags),
                  ),
            ];
            return SuggestionList(
              children: [
                for (final Tag tag in shownTags ?? const <Tag>[])
                  SuggestionRow(
                    label: '$prefix${tag.name}',
                    meta: NumberFormat.compact().format(tag.count),
                    stripe: tagCategoryOf(tag.category)?.color,
                    onTap: () => onPick('$prefix${tag.name}'),
                  ),
                ...recent.take(3),
                ...saved.take(3),
              ],
            );
          },
        ),
      ),
    );
  }
}

class SuggestionList extends StatelessWidget {
  const SuggestionList({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ListView(
    reverse: true,
    primary: false,
    padding: const EdgeInsets.symmetric(vertical: 8),
    children: children,
  );
}

class SuggestionRow extends StatelessWidget {
  const SuggestionRow({
    super.key,
    required this.label,
    required this.meta,
    required this.onTap,
    this.stripe,
    this.icon,
  });

  final String label;
  final String meta;
  final VoidCallback onTap;
  final Color? stripe;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String prefix = label.length > 1 && label[0] == '-' ? '-' : '';
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            spacing: 12,
            children: [
              SizedBox(
                width: 20,
                child: icon != null
                    ? Icon(icon, size: 18, color: dimTextColor(context))
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 3,
                          height: 20,
                          color:
                              stripe ??
                              theme.colorScheme.onSurface.withValues(
                                alpha: 0.38,
                              ),
                        ),
                      ),
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      if (prefix.isNotEmpty)
                        TextSpan(
                          text: prefix,
                          style: TextStyle(color: Colors.red.shade300),
                        ),
                      TextSpan(
                        text: label
                            .substring(prefix.length)
                            .replaceAll('_', ' '),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 15),
                ),
              ),
              Text(
                meta,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: dimTextColor(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
