import 'package:e1547/client/client.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/set/set.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

String? setNameOf(String term) {
  final meta = splitMeta(term);
  if (meta == null || meta.key != 'set') return null;
  return meta.value;
}

class PoolSetBuilder extends StatefulWidget {
  const PoolSetBuilder({
    super.key,
    required this.controller,
    this.me,
    this.onOpenPool,
  });

  final QueryFieldController controller;
  final String? me;
  final ValueChanged<Pool>? onOpenPool;

  @override
  State<PoolSetBuilder> createState() => _PoolSetBuilderState();
}

class _PoolSetBuilderState extends State<PoolSetBuilder> {
  late bool sets =
      widget.me != null &&
      widget.controller.terms.any((e) => setNameOf(e) != null);

  void _write(String key, String? term) =>
      widget.controller.replaceWhere((e) => splitMeta(e)?.key == key, [?term]);

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, child) {
      final List<String> terms = widget.controller.terms;
      final int? pool = terms.map(poolIdOf).nonNulls.firstOrNull;
      final String? set = terms.map(setNameOf).nonNulls.firstOrNull;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          if (widget.me != null)
            MetaSegments<bool>(
              values: const [false, true],
              label: (value) => value ? 'Sets' : 'Pools',
              selected: sets,
              onPick: (value) => setState(() => sets = value),
            ),
          if (sets)
            OwnSetChoices(
              me: widget.me!,
              picked: set,
              onPick: (value) =>
                  _write('set', value == set ? null : 'set:$value'),
            )
          else if (pool != null)
            PickedPool(
              id: pool,
              onRemove: () => _write('pool', null),
              onOpen: widget.onOpenPool,
            )
          else
            RecentPoolChoices(onPick: (value) => _write('pool', 'pool:$value')),
        ],
      );
    },
  );
}

class RecentPoolChoices extends StatelessWidget {
  const RecentPoolChoices({super.key, required this.onPick});

  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    final Client client = context.watch<Client>();
    return QueryBuilder(
      query: client.pools.useSearch(
        query: const PoolParams().toQuery(),
        limit: 4,
      ),
      builder: (context, state) {
        final List<Pool> pools = state.data ?? const [];
        prefetchCovers(client, pools.map((e) => e.postIds.firstOrNull));
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10,
          children: [
            const MetaLabel('Recently updated'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                for (int i = 0; i < 4; i++)
                  Expanded(
                    child: i < pools.length
                        ? PoolChoice(
                            pool: pools[i],
                            onTap: () => onPick(pools[i].id),
                          )
                        : const SizedBox.shrink(),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class PoolChoice extends StatelessWidget {
  const PoolChoice({super.key, required this.pool, required this.onTap});

  final Pool pool;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 4,
        children: [
          SizedBox(
            height: 92,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: PostCover(id: pool.postIds.firstOrNull),
            ),
          ),
          Text(
            tagToName(pool.name),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
          Text(
            poolCountWords(pool),
            style: TextStyle(
              fontSize: 11,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class PickedPool extends StatelessWidget {
  const PickedPool({
    super.key,
    required this.id,
    required this.onRemove,
    this.onOpen,
  });

  final int id;
  final VoidCallback onRemove;
  final ValueChanged<Pool>? onOpen;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return QueryBuilder(
      query: context.watch<Client>().pools.useGet(id: id),
      builder: (context, state) {
        final Pool? pool = state.data;
        if (pool == null) return const SizedBox(height: 52);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10,
          children: [
            CoverRow(
              cover: pool.postIds.firstOrNull,
              title: tagToName(pool.name),
              subtitle: Text(poolSubtitle(pool)),
              trailing: Icon(Icons.check, color: theme.colorScheme.primary),
              onTap: onRemove,
            ),
            if (onOpen case final open?)
              Material(
                color: metaWell(theme),
                borderRadius: BorderRadius.circular(4),
                child: InkWell(
                  onTap: () => open(pool),
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 4, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Open the pool as pages',
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class OwnSetChoices extends StatelessWidget {
  const OwnSetChoices({
    super.key,
    required this.me,
    required this.picked,
    required this.onPick,
  });

  final String me;
  final String? picked;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Client client = context.watch<Client>();
    return QueryBuilder(
      query: client.sets.useSearch(query: PostSetParams(creator: me).toQuery()),
      builder: (context, state) {
        final List<PostSet> sets = state.data ?? const [];
        prefetchCovers(client, sets.map((e) => e.postIds.firstOrNull));
        if (sets.isEmpty && state.data != null) {
          return const MetaLabel('You have no sets');
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final PostSet set in sets)
              CoverRow(
                cover: set.postIds.firstOrNull,
                title: tagToName(set.name),
                subtitle: Text(
                  [
                    postSetCountWords(set),
                    if (set.public) 'public',
                  ].join(' · '),
                ),
                trailing: set.shortname == picked
                    ? Icon(Icons.check, color: theme.colorScheme.primary)
                    : null,
                onTap: () => onPick(set.shortname),
              ),
          ],
        );
      },
    );
  }
}
