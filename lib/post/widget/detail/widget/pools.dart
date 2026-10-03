import 'package:collection/collection.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

class PoolDisplay extends StatelessWidget {
  const PoolDisplay({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final List<int> pools = post.pools ?? const [];
    if (pools.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RelationHeader(title: AppLocalizations.of(context).navPools),
        ...pools.map((id) => PoolRelationTile(id: id)),
        const Divider(),
      ],
    );
  }
}

/// Pool shown with its name and size, previewed by its first post.
class PoolRelationTile extends StatelessWidget {
  const PoolRelationTile({super.key, required this.id});

  final int id;

  static const double previewSize = 56;

  @override
  Widget build(BuildContext context) {
    final Client client = context.watch<Client>();
    void open() => Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => PoolLoadingPage(id)));

    return QueryBuilder(
      query: client.pools.useGet(id: id),
      builder: (context, state) {
        final Pool? pool = state.data;
        final int? preview = pool?.postIds.firstOrNull;
        return InkWell(
          onTap: open,
          child: Row(
            children: [
              if (preview != null)
                PostRelationPreview(id: preview, size: previewSize, onTap: open)
              else
                RelationPreviewCard(
                  size: previewSize,
                  onTap: open,
                  child: RelationPreviewIcon(
                    icon: state.error != null
                        ? Icons.warning_amber_outlined
                        : null,
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      pool == null ? '#$id' : tagToName(pool.name),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    CrossFade(
                      showChild: pool != null,
                      child: pool == null
                          ? const SizedBox.shrink()
                          : Text(
                              AppLocalizations.of(
                                context,
                              ).detailPoolPosts(pool.postCount),
                              style: TextStyle(color: dimTextColor(context)),
                            ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_right),
            ],
          ),
        );
      },
    );
  }
}
