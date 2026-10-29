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

const int searchSheetEntries = 5;
const double searchSheetLabelWidth = 320;

Future<void> showPostSearchSheet(
  BuildContext context, {
  AnimationController? transition,
}) {
  final PostParamsController params = context.read<PostParamsController>();
  final PostFilter filter = context.read<PostFilter>();
  final NavigatorState page = Navigator.of(context);
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    transitionAnimationController: transition,
    builder: (sheetContext) => FloatingSheet(
      child: PostSearchSheet(
        query: params.value.tags ?? '',
        posts: filter.tracked.where(filter.filter).toList(),
        filter: filter,
        onShowHidden: () => showHiddenPostsSheet(context, filter),
        onAllRecent: () {
          Navigator.of(sheetContext).pop();
          page.push(
            MaterialPageRoute(builder: (context) => const HistoriesPage()),
          );
        },
        onSubmit: (value) =>
            params.update((p) => p.copyWith(tags: TagMap(value).toString())),
      ),
    ),
  );
}

class FloatingSheet extends StatelessWidget {
  const FloatingSheet({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MediaQueryData media = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        12,
        0,
        12,
        16 + media.viewPadding.bottom + media.viewInsets.bottom,
      ),
      child: Material(
        color: theme.cardColor,
        elevation: 8,
        shadowColor: Colors.black,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: child,
        ),
      ),
    );
  }
}

class SheetGrip extends StatelessWidget {
  const SheetGrip({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Container(
        width: 32,
        height: 3,
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
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

class PostSearchSheet extends StatefulWidget {
  const PostSearchSheet({
    super.key,
    required this.query,
    required this.onSubmit,
    this.posts = const [],
    this.filter,
    this.onShowHidden,
    this.onAllRecent,
  });

  final String query;
  final ValueSetter<String> onSubmit;
  final List<Post> posts;
  final PostFilter? filter;
  final VoidCallback? onShowHidden;
  final VoidCallback? onAllRecent;

  @override
  State<PostSearchSheet> createState() => _PostSearchSheetState();
}

class _PostSearchSheetState extends State<PostSearchSheet> {
  late final QueryFieldController controller = QueryFieldController(
    query: widget.query,
  );
  final FocusNode focus = FocusNode();
  final Map<String, TagPreview> previews = {};
  PostSearchSheetTab tab = PostSearchSheetTab.recent;
  bool catalog = false;
  MetaKind? building;

  bool get panel => catalog || building != null;

  @override
  void initState() {
    super.initState();
    focus.addListener(_onFocus);
  }

  void _onFocus() {
    if (focus.hasFocus && panel) {
      setState(() {
        catalog = false;
        building = null;
      });
    }
  }

  void _openPanel(MetaKind? kind) {
    focus.unfocus();
    setState(() {
      catalog = true;
      building = kind;
    });
  }

  void _closePanel() => setState(() {
    catalog = false;
    building = null;
  });

  void _tapChip(int index) {
    final MetaKind? kind = metaKindOf(controller.terms[index]);
    if (kind != null && builtMetaKinds.contains(kind)) {
      _openPanel(kind);
    } else {
      controller.select(index);
    }
  }

  @override
  void dispose() {
    focus.removeListener(_onFocus);
    controller.dispose();
    focus.dispose();
    super.dispose();
  }

  void submit([String? query]) {
    widget.onSubmit(query ?? controller.query);
    Navigator.of(context).pop();
  }

  void append(String tag) => controller.commit(tag);

  int? unknownIn(List<String> terms) {
    for (int i = terms.length - 1; i >= 0; i--) {
      final String name = tagWithoutPrefix(terms[i]);
      if (name.contains(':')) continue;
      if (previews[name]?.postCount == 0) return i;
    }
    return null;
  }

  Widget body(int? unknown) {
    if (controller.selected case final int index) {
      return QueryChipActions(
        term: controller.terms[index],
        onChange: (term) => controller.replace(index, term),
        onRemove: () => controller.remove(index),
      );
    }
    if (controller.typed.isNotEmpty) {
      return PostSearchSuggestions(typed: controller.typed, onPick: append);
    }
    if (unknown != null) {
      final String term = controller.terms[unknown];
      final String prefix = term.substring(
        0,
        term.length - tagWithoutPrefix(term).length,
      );
      return PostSearchSuggestions(
        typed: term,
        onPick: (value) => controller.replace(
          unknown,
          value.startsWith(prefix) ? value : '$prefix$value',
        ),
      );
    }
    return switch (tab) {
      PostSearchSheetTab.recent => RecentPostSearches(
        onPick: submit,
        onAll: widget.onAllRecent,
      ),
      PostSearchSheetTab.saved => SavedPostSearches(onPick: submit),
      PostSearchSheetTab.results => ResultTags(
        posts: widget.posts,
        onAdd: append,
        onExclude: (tag) => append('-$tag'),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool typing = MediaQuery.viewInsetsOf(context).bottom > 0;
    final bool left = Handedness.of(context) == Handedness.left;
    final Color well = Color.alphaBlend(
      theme.colorScheme.onSurface.withValues(alpha: 0.04),
      theme.cardColor,
    );
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) => QueryBuilder(
        query: context.watch<Client>().tags.usePreview(
          names: controller.terms
              .map(tagWithoutPrefix)
              .where((e) => !e.contains(':'))
              .toList(),
        ),
        builder: (context, state) {
          for (final TagPreview preview in state.data ?? const <TagPreview>[]) {
            previews[preview.name] = preview;
          }
          final int? unknown = unknownIn(controller.terms);
          final bool tabs =
              !panel &&
              controller.selected == null &&
              controller.typed.isEmpty &&
              unknown == null;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SheetGrip(),
              if (!panel) body(unknown),
              if (tabs)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
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
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final bool compact =
                        constraints.maxWidth < searchSheetLabelWidth;
                    return Row(
                      textDirection: left
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      spacing: 6,
                      children: [
                        if (widget.filter case final filter?
                            when widget.onShowHidden != null)
                          ListenableBuilder(
                            listenable: filter,
                            builder: (context, child) {
                              if (filter.matchCountsByEntry.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return SheetButton(
                                color: well,
                                onTap: widget.onShowHidden!,
                                icon: Icons.block,
                                label: compact ? null : 'Blacklist',
                                tooltip: 'Blacklist',
                                count: filter.blockedCount,
                              );
                            },
                          ),
                        SheetButton(
                          color: well,
                          selected: panel,
                          onTap: panel ? _closePanel : () => _openPanel(null),
                          icon: Icons.tune,
                          label: compact ? null : 'Filters',
                          tooltip: 'Filters',
                        ),
                        const Spacer(),
                        SizedBox.square(
                          dimension: typing ? 44 : 48,
                          child: Material(
                            color: theme.colorScheme.secondary,
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
                    );
                  },
                ),
              ),
              Padding(
                key: const ValueKey('field'),
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 4,
                  children: [
                    QueryField(
                      controller: controller,
                      focusNode: focus,
                      onSubmit: submit,
                      onChipTap: _tapChip,
                      previews: previews,
                      color: well,
                    ),
                    if (unknown != null)
                      Text(
                        '${tagToTitle(tagWithoutPrefix(controller.terms[unknown]))} '
                        'has no posts. Did you mean one of these?',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                  ],
                ),
              ),
              if (panel)
                Flexible(
                  child: SingleChildScrollView(
                    primary: false,
                    child: MetaPanel(
                      controller: controller,
                      me: context.watch<Client>().identity.username,
                      kind: building,
                      onPick: _openPanel,
                      onBack: building != null
                          ? () => _openPanel(null)
                          : _closePanel,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class SheetButton extends StatelessWidget {
  const SheetButton({
    super.key,
    required this.color,
    required this.onTap,
    required this.icon,
    required this.tooltip,
    this.label,
    this.count,
    this.selected = false,
  });

  final Color color;
  final VoidCallback onTap;
  final IconData icon;
  final String tooltip;
  final String? label;
  final int? count;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final Color accent = Theme.of(context).colorScheme.primary;
    final Widget button = Material(
      color: selected ? accent.withValues(alpha: 0.16) : color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: selected ? accent : Colors.transparent),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          height: 32,
          child: Padding(
            padding: label == null && count == null
                ? const EdgeInsets.symmetric(horizontal: 8)
                : const EdgeInsets.fromLTRB(8, 0, 10, 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 6,
              children: [
                Icon(icon, size: 16, color: selected ? accent : null),
                if (label != null)
                  Text(
                    label!,
                    style: TextStyle(
                      fontSize: 13,
                      color: selected ? accent : null,
                    ),
                  ),
                if (count != null)
                  Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    if (label != null) return button;
    return Tooltip(message: tooltip, child: button);
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
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: selected ? theme.colorScheme.primary : Colors.transparent,
            ),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}

class SheetLink extends StatelessWidget {
  const SheetLink({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color accent = Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 8, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: accent,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: accent),
            ],
          ),
        ),
      ),
    );
  }
}

class SheetEntry extends StatelessWidget {
  const SheetEntry({
    super.key,
    required this.icon,
    required this.child,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final Widget child;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color dim = theme.colorScheme.onSurface.withValues(alpha: 0.45);
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
            Icon(icon, size: 20, color: dim),
            Expanded(child: child),
            if (trailing != null)
              DefaultTextStyle.merge(
                style: TextStyle(fontSize: 12, color: dim),
                child: trailing!,
              ),
          ],
        ),
      ),
    );
  }
}

String? postSearchTags(History entry) =>
    Uri.tryParse(entry.link)?.queryParameters['tags']?.trim();

class RecentPostSearches extends StatelessWidget {
  const RecentPostSearches({super.key, required this.onPick, this.onAll});

  final ValueSetter<String> onPick;
  final VoidCallback? onAll;

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
        final List<MapEntry<String, History>> newest = searches.entries
            .take(searchSheetEntries)
            .toList();
        if (newest.isEmpty) return const SizedBox.shrink();
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (onAll != null)
              SheetLink(label: 'All searches in History', onTap: onAll!),
            for (final MapEntry(key: tags, value: entry) in newest.reversed)
              SheetEntry(
                icon: Icons.history,
                onTap: () => onPick(tags),
                trailing: Text(entry.visitedAt.relativeTime(context)),
                child: QueryChipRow(query: tags),
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
      builder: (context, state) {
        final List<Follow> follows = (state.data ?? const <Follow>[])
            .take(searchSheetEntries)
            .toList();
        if (follows.isEmpty) return const SizedBox.shrink();
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final Follow follow in follows)
              SheetEntry(
                icon: switch (follow.type) {
                  FollowType.notify => Icons.notifications_active,
                  FollowType.update => Icons.person_add,
                  FollowType.bookmark => Icons.bookmark,
                },
                onTap: () => onPick(follow.tags),
                trailing: (follow.unseen ?? 0) > 0
                    ? Container(
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
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    if (follow.title != null) Text(follow.title!),
                    QueryChipRow(query: follow.tags),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class ResultTags extends StatelessWidget {
  const ResultTags({
    super.key,
    required this.posts,
    required this.onAdd,
    required this.onExclude,
    this.limit = 15,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
      color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
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
