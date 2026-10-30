import 'dart:math';

import 'package:e1547/client/client.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

String poolPlaceWords(Pool pool, int postId) {
  final int index = pool.postIds.indexOf(postId);
  return [
    poolKindWords(pool.category),
    if (index >= 0)
      'page ${index + 1} of ${pool.postIds.length}'
    else
      poolCountWords(pool),
  ].join(' · ');
}

class PostPoolsSection extends StatelessWidget {
  const PostPoolsSection({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final List<int> pools = post.pools ?? const [];
    if (pools.isEmpty) return const SizedBox.shrink();
    return QueryBuilder(
      query: context.watch<Client>().pools.useGet(id: pools.first),
      builder: (context, state) => PostDetailSection(
        section: PostSection.pools,
        label: 'Pools',
        count: pools.length,
        summary: state.data == null
            ? '#${pools.first}'
            : '${tagToName(state.data!.name)} · '
                  '${poolPlaceWords(state.data!, post.id)}',
        child: Column(
          spacing: 8,
          children: [
            for (final int id in pools) PostPoolEntry(post: post, id: id),
          ],
        ),
      ),
    );
  }
}

class PostPoolEntry extends StatelessWidget {
  const PostPoolEntry({super.key, required this.post, required this.id});

  final Post post;
  final int id;

  static const int strip = 5;

  @override
  Widget build(BuildContext context) {
    final Client client = context.watch<Client>();
    final Color dim = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.55);
    return QueryBuilder(
      query: client.pools.useGet(id: id),
      builder: (context, state) {
        final Pool? pool = state.data;
        final List<int> ids = pool?.postIds ?? const [];
        final int index = max(ids.indexOf(post.id), 0);
        final int start = max(0, min(index - strip ~/ 2, ids.length - strip));
        final List<int> shown = ids.skip(start).take(strip).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PoolLoadingPage(id)),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            pool == null ? '#$id' : tagToName(pool.name),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 15),
                          ),
                          if (pool != null)
                            Text(
                              poolPlaceWords(pool, post.id),
                              style: TextStyle(fontSize: 12, color: dim),
                            ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: dim),
                  ],
                ),
              ),
            ),
            if (shown.isNotEmpty)
              Row(
                spacing: 4,
                children: [
                  for (int slot = 0; slot < strip; slot++)
                    Expanded(
                      child: slot < shown.length
                          ? PostThumbnail(
                              id: shown[slot],
                              height: 72,
                              current: shown[slot] == post.id,
                            )
                          : const SizedBox(),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}
