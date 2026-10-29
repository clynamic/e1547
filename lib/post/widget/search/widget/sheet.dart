import 'dart:math';

import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';
import 'package:relative_time/relative_time.dart';

Future<void> showPostSearchSheet(BuildContext context) {
  final PostParamsController params = context.read<PostParamsController>();
  final PostFilter filter = context.read<PostFilter>();
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).canvasColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
    ),
    builder: (sheetContext) => PostSearchSheet(
      query: params.value.tags ?? '',
      posts: filter.tracked.where(filter.filter).toList(),
      filter: filter,
      onShowHidden: () => showHiddenPostsSheet(context, filter),
      onSubmit: (value) =>
          params.update((p) => p.copyWith(tags: TagMap(value).toString())),
    ),
  );
}

enum PostSearchSheetTab {
  recent('Recent'),
  saved('Saved'),
  results('In results');

  const PostSearchSheetTab(this.label);

  final String label;
}

const double searchSheetRestingTop = 120;
const double searchSheetTypingTop = 40;

class PostSearchSheet extends StatefulWidget {
  const PostSearchSheet({
    super.key,
    required this.query,
    required this.onSubmit,
    this.posts = const [],
    this.filter,
    this.onShowHidden,
  });

  final String query;
  final ValueSetter<String> onSubmit;
  final List<Post> posts;
  final PostFilter? filter;
  final VoidCallback? onShowHidden;

  @override
  State<PostSearchSheet> createState() => _PostSearchSheetState();
}

class _PostSearchSheetState extends State<PostSearchSheet> {
  late final TextEditingController controller = TextEditingController(
    text: widget.query.isEmpty ? '' : '${widget.query} ',
  );
  PostSearchSheetTab tab = PostSearchSheetTab.recent;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void submit([String? query]) {
    widget.onSubmit(query ?? controller.text);
    Navigator.of(context).pop();
  }

  void append(String tag) {
    final String text = '${controller.text.trimRight()} $tag '.trimLeft();
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MediaQueryData media = MediaQuery.of(context);
    final bool typing = media.viewInsets.bottom > 0;
    final bool left = Handedness.of(context) == Handedness.left;
    final double height =
        media.size.height -
        media.viewInsets.bottom -
        (typing ? searchSheetTypingTop : searchSheetRestingTop);
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
      ),
    );
    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: SizedBox(
        height: max(0, height),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  width: 32,
                  height: 3,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Expanded(
                child: switch (tab) {
                  PostSearchSheetTab.recent => RecentPostSearches(
                    onPick: submit,
                  ),
                  PostSearchSheetTab.saved => SavedPostSearches(onPick: submit),
                  PostSearchSheetTab.results => ResultTags(
                    posts: widget.posts,
                    onAdd: append,
                    onExclude: (tag) => append('-$tag'),
                  ),
                },
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.12,
                      ),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    for (final PostSearchSheetTab value
                        in PostSearchSheetTab.values)
                      Expanded(
                        child: SearchSheetTab(
                          label: value.label,
                          selected: value == tab,
                          onTap: () => setState(() => tab = value),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  spacing: 10,
                  children: [
                    Row(
                      textDirection: left
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      spacing: 8,
                      children: [
                        if (widget.filter case final filter?
                            when widget.onShowHidden != null)
                          ListenableBuilder(
                            listenable: filter,
                            builder: (context, child) {
                              if (filter.matchCountsByEntry.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Material(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(4),
                                child: InkWell(
                                  onTap: widget.onShowHidden,
                                  borderRadius: BorderRadius.circular(4),
                                  child: SizedBox(
                                    height: 40,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Center(
                                        widthFactor: 1,
                                        child: HiddenCount(
                                          count: filter.blockedCount,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        const Spacer(),
                        SizedBox.square(
                          dimension: dockHeight,
                          child: Material(
                            color: theme.colorScheme.secondary,
                            elevation: 3,
                            borderRadius: BorderRadius.circular(8),
                            child: InkWell(
                              onTap: submit,
                              borderRadius: BorderRadius.circular(8),
                              child: Icon(
                                Icons.search,
                                color: theme.colorScheme.onSecondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TagInput(
                      controller: controller,
                      autofocus: false,
                      direction: VerticalDirection.up,
                      textInputAction: TextInputAction.search,
                      submit: (_) => submit(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: theme.cardColor,
                        border: border,
                        enabledBorder: border,
                        focusedBorder: border.copyWith(
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchSheetTab extends StatelessWidget {
  const SearchSheetTab({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.7);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 2,
              color: selected ? theme.colorScheme.primary : Colors.transparent,
            ),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

String? postSearchTags(History entry) =>
    Uri.tryParse(entry.link)?.queryParameters['tags']?.trim();

class RecentPostSearches extends StatelessWidget {
  const RecentPostSearches({super.key, required this.onPick});

  final ValueSetter<String> onPick;

  @override
  Widget build(BuildContext context) {
    final Client client = context.watch<Client>();
    return QueryBuilder(
      query: client.histories.useRecentSearches(type: HistoryType.posts),
      builder: (context, state) {
        final Map<String, History> searches = {};
        for (final History entry in state.data ?? const <History>[]) {
          final String? tags = postSearchTags(entry);
          if (tags == null || tags.isEmpty) continue;
          searches.putIfAbsent(tags, () => entry);
        }
        return ListView(
          reverse: true,
          primary: false,
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            for (final MapEntry(key: tags, value: entry) in searches.entries)
              SearchSheetRow(
                onTap: () => onPick(tags),
                child: Row(
                  spacing: 12,
                  children: [
                    Expanded(child: QueryLine(query: tags)),
                    Text(
                      entry.visitedAt.relativeTime(context),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: dimTextColor(context),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class SavedPostSearches extends StatelessWidget {
  const SavedPostSearches({super.key, required this.onPick});

  final ValueSetter<String> onPick;

  @override
  Widget build(BuildContext context) {
    final Client client = context.watch<Client>();
    final ThemeData theme = Theme.of(context);
    return QueryBuilder(
      query: client.follows.useAll(),
      builder: (context, state) => ListView(
        reverse: true,
        primary: false,
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          for (final Follow follow in state.data ?? const <Follow>[])
            SearchSheetRow(
              onTap: () => onPick(follow.tags),
              child: Row(
                spacing: 12,
                children: [
                  Icon(
                    switch (follow.type) {
                      FollowType.notify => Icons.notifications_active,
                      FollowType.update => Icons.person_add,
                      FollowType.bookmark => Icons.bookmark,
                    },
                    size: 20,
                    color: dimTextColor(context),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        if (follow.title != null) Text(follow.title!),
                        QueryLine(query: follow.tags),
                      ],
                    ),
                  ),
                  if ((follow.unseen ?? 0) > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        '${follow.unseen}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class SearchSheetRow extends StatelessWidget {
  const SearchSheetRow({super.key, required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 52),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Align(alignment: Alignment.centerLeft, child: child),
      ),
    ),
  );
}

class ResultTags extends StatelessWidget {
  const ResultTags({
    super.key,
    required this.posts,
    required this.onAdd,
    required this.onExclude,
    this.limit = 30,
  });

  final List<Post> posts;
  final ValueSetter<String> onAdd;
  final ValueSetter<String> onExclude;
  final int limit;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<CountedTag> tags = countTagsByPosts(posts)
      ..sort((a, b) => b.count.compareTo(a.count));
    if (tags.isEmpty) return const SizedBox.shrink();
    return SingleChildScrollView(
      reverse: true,
      primary: false,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            'Tap a tag to add it. Hold it to exclude it.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: dimTextColor(context),
            ),
          ),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            verticalDirection: VerticalDirection.up,
            children: [
              for (final CountedTag tag in tags.take(limit))
                ResultTag(
                  tag: tag,
                  onTap: () => onAdd(tag.tag),
                  onLongPress: () => onExclude(tag.tag),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class ResultTag extends StatelessWidget {
  const ResultTag({
    super.key,
    required this.tag,
    required this.onTap,
    required this.onLongPress,
  });

  final CountedTag tag;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: SizedBox(
          height: 32,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 3,
                color: TagCategory.byName(tag.category)?.color,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(7, 0, 6, 0),
                child: Text(tagToTitle(tag.tag)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.08,
                      ),
                    ),
                  ),
                ),
                child: Text(
                  '${tag.count}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: dimTextColor(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
