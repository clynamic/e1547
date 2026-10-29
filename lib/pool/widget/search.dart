import 'package:e1547/client/client.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

final DateFormat poolDateWords = DateFormat('d MMM');

String poolCountWords(Pool pool) => switch (pool.category) {
  PoolCategory.series => '${pool.postCount} pages',
  PoolCategory.collection => '${pool.postCount} posts',
};

String poolSubtitle(Pool pool, {bool detailed = false}) => [
  switch (pool.category) {
    PoolCategory.series => 'Series',
    PoolCategory.collection => 'Collection',
  },
  poolCountWords(pool),
  if (detailed && pool.category == PoolCategory.series)
    if (pool.active)
      'updated ${poolDateWords.format(pool.updatedAt)}'
    else
      'finished',
].join(' · ');

String poolParamsWords(PoolParams params) {
  final PoolOrder order = params.order ?? PoolOrder.updatedAt;
  if (params.name?.isEmpty ?? true) {
    return [
      if (params.category != null) params.category!.label,
      order.label,
    ].join(' · ');
  }
  return [
    params.category?.label ?? 'Series and collections',
    order.words,
  ].join(' · ');
}

void openPool(BuildContext context, Pool pool) => Navigator.of(
  context,
).push(MaterialPageRoute(builder: (context) => PoolPage(pool: pool)));

class PoolCard extends StatelessWidget {
  const PoolCard({super.key, required this.pool, required this.onTap});

  final Pool pool;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        onLongPress: () => showPoolPrompt(context: context, pool: pool),
        borderRadius: BorderRadius.circular(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 6,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: PostCover(
                id: pool.postIds.firstOrNull,
                size: PostImageSize.sample,
                adaptive: true,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tagToName(pool.name),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  poolSubtitle(pool),
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
  final String subtitle;
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
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
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

class SliverPoolGrid extends StatelessWidget {
  const SliverPoolGrid({super.key, required this.state, required this.query});

  final InfiniteQueryStatus<List<Pool>, int> state;
  final InfiniteQuery<List<int>, int> query;

  @override
  Widget build(BuildContext context) => PagedSliverMasonryGrid<int, Pool>.count(
    showNewPageProgressIndicatorAsGridChild: false,
    showNewPageErrorIndicatorAsGridChild: false,
    showNoMoreItemsIndicatorAsGridChild: false,
    state: state.paging,
    fetchNextPage: query.getNextPage,
    crossAxisCount: (TileLayout.of(context).crossAxisCount * 0.5).round().clamp(
      2,
      8,
    ),
    crossAxisSpacing: 8,
    builderDelegate: defaultPagedChildBuilderDelegate<Pool>(
      onRetry: query.getNextPage,
      itemBuilder: (context, item, index) => ImageCacheSizeProvider(
        size: TileLayout.of(context).tileSize * 2,
        child: PoolCard(pool: item, onTap: () => openPool(context, item)),
      ),
      onEmpty: const Text('No pools'),
      onError: const Text('Failed to load pools'),
    ),
  );
}

class PoolDock extends StatelessWidget {
  const PoolDock({super.key, required this.params, required this.onOpen});

  final PoolParamsController params;
  final Future<void> Function(AnimationController? transition) onOpen;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SearchDock(
      onOpen: onOpen,
      child: ListenableBuilder(
        listenable: params,
        builder: (context, child) {
          final String name = params.value.name ?? '';
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.isEmpty ? 'Pool name' : name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  color: name.isEmpty
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.45)
                      : null,
                ),
              ),
              Text(
                poolParamsWords(params.value),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Future<void> showPoolSearchSheet(
  BuildContext context, {
  AnimationController? transition,
}) {
  final PoolParamsController params = context.read<PoolParamsController>();
  final NavigatorState page = Navigator.of(context);
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    transitionAnimationController: transition,
    builder: (sheetContext) => FloatingSheet(
      child: PoolSearchSheet(
        params: params.value,
        onSubmit: (value) => params.value = value,
        onOpen: (pool) {
          Navigator.of(sheetContext).pop();
          page.push(
            MaterialPageRoute(builder: (context) => PoolPage(pool: pool)),
          );
        },
      ),
    ),
  );
}

class PoolSearchSheet extends StatefulWidget {
  const PoolSearchSheet({
    super.key,
    required this.params,
    required this.onSubmit,
    required this.onOpen,
  });

  final PoolParams params;
  final ValueChanged<PoolParams> onSubmit;
  final ValueChanged<Pool> onOpen;

  @override
  State<PoolSearchSheet> createState() => _PoolSearchSheetState();
}

class _PoolSearchSheetState extends State<PoolSearchSheet> {
  late final TextEditingController text = TextEditingController(
    text: widget.params.name,
  );
  final FocusNode focus = FocusNode();
  late PoolParams params = widget.params;
  bool filters = false;

  @override
  void initState() {
    super.initState();
    focus.addListener(_onFocus);
  }

  void _onFocus() {
    if (focus.hasFocus && filters) setState(() => filters = false);
  }

  @override
  void dispose() {
    focus.removeListener(_onFocus);
    text.dispose();
    focus.dispose();
    super.dispose();
  }

  void submit() {
    final String name = text.text.trim();
    widget.onSubmit(params.copyWith(name: name.isEmpty ? null : name));
    Navigator.of(context).pop();
  }

  void _toggleFilters() {
    if (!filters) focus.unfocus();
    setState(() => filters = !filters);
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
      listenable: Listenable.merge([text, focus]),
      builder: (context, child) {
        final String typed = text.text.trim();
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetGrip(),
            if (!filters && typed.isNotEmpty)
              PoolSuggestions(
                params: params.copyWith(name: typed),
                onPick: widget.onOpen,
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
              child: Row(
                textDirection: left ? TextDirection.rtl : TextDirection.ltr,
                spacing: 6,
                children: [
                  SheetButton(
                    color: well,
                    selected: filters,
                    onTap: _toggleFilters,
                    icon: Icons.tune,
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
              ),
            ),
            Padding(
              key: const ValueKey('field'),
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: SheetTextField(
                controller: text,
                focusNode: focus,
                hint: 'Pool name',
                color: well,
                onSubmit: submit,
              ),
            ),
            if (filters)
              Flexible(
                child: SingleChildScrollView(
                  primary: false,
                  child: PoolFilterPanel(
                    params: params,
                    onChange: (value) => setState(() => params = value),
                    onClose: _toggleFilters,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class SheetTextField extends StatelessWidget {
  const SheetTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.color,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final Color color;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: color),
    );
    return TextField(
      controller: controller,
      focusNode: focusNode,
      autocorrect: false,
      enableSuggestions: false,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => onSubmit(),
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: color,
        hintText: hint,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 13,
        ),
        enabledBorder: border(
          theme.colorScheme.onSurface.withValues(alpha: 0.12),
        ),
        focusedBorder: border(theme.colorScheme.primary.withValues(alpha: 0.6)),
      ),
    );
  }
}

class PoolSuggestions extends StatelessWidget {
  const PoolSuggestions({
    super.key,
    required this.params,
    required this.onPick,
  });

  final PoolParams params;
  final ValueChanged<Pool> onPick;

  @override
  Widget build(BuildContext context) {
    final Client client = context.watch<Client>();
    return QueryBuilder(
      query: client.pools.useSearch(query: params.toQuery()),
      builder: (context, state) {
        final List<Pool> pools = (state.data ?? const <Pool>[])
            .take(searchSheetEntries)
            .toList();
        if (pools.isEmpty) return const SizedBox.shrink();
        prefetchCovers(client, pools.map((e) => e.postIds.firstOrNull));
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final Pool pool in pools)
                CoverRow(
                  cover: pool.postIds.firstOrNull,
                  title: tagToName(pool.name),
                  subtitle: poolSubtitle(pool, detailed: true),
                  onTap: () => onPick(pool),
                ),
            ],
          ),
        );
      },
    );
  }
}

class PoolFilterPanel extends StatelessWidget {
  const PoolFilterPanel({
    super.key,
    required this.params,
    required this.onChange,
    required this.onClose,
  });

  final PoolParams params;
  final ValueChanged<PoolParams> onChange;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final PoolOrder order = params.order ?? PoolOrder.updatedAt;
    return SheetPanel(
      title: 'Filters',
      onClose: onClose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          MetaChoices<PoolCategory>(
            label: 'Kind',
            options: PoolCategory.values,
            name: (value) => value.label,
            selected: params.category,
            onPick: (value) => onChange(params.copyWith(category: value)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 6,
            children: [
              const MetaLabel('Order'),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final PoolOrder value in PoolOrder.values)
                    MetaOption(
                      label: value.label,
                      selected: value == order,
                      onTap: () => onChange(
                        params.copyWith(
                          order: value == PoolOrder.updatedAt ? null : value,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SheetPanel extends StatelessWidget {
  const SheetPanel({
    super.key,
    required this.title,
    required this.onClose,
    required this.child,
  });

  final String title;
  final VoidCallback onClose;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: Color.alphaBlend(
        Colors.black.withValues(alpha: 0.15),
        theme.cardColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 44,
            padding: const EdgeInsets.fromLTRB(4, 0, 8, 0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
                ),
              ),
            ),
            child: Row(
              spacing: 8,
              children: [
                IconButton(
                  tooltip: 'Close',
                  onPressed: onClose,
                  icon: const Icon(Icons.keyboard, size: 20),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }
}
