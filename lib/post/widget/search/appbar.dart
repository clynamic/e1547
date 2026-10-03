import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';

class PostPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PostPageAppBar({super.key, this.actions});

  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PostParamsController>();
    final map = TagMap(controller.value.tags);
    final showInfo =
        map.isNotEmpty && map['order'] != 'rank' && map['fav'] == null;

    return DefaultAppBar(
      title: const _PostPageTitle(),
      actions: [
        if (showInfo) const _PostPageInfoButton(),
        if (controller.canSearch) const PostsPageFilterButton(),
        ...?actions,
        const ContextDrawerButton(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PostPageInfoButton extends StatelessWidget {
  const _PostPageInfoButton();

  @override
  Widget build(BuildContext context) {
    final params = context.watch<PostParamsController>().value;
    final tags = params.tags ?? '';
    final poolId = params.poolId;

    Widget button({Pool? pool}) => IconButton(
      icon: const Icon(Icons.info_outline),
      onPressed: () => pool != null
          ? showPoolPrompt(context: context, pool: pool)
          : showTagSearchPrompt(context: context, tag: tags),
    );

    if (poolId == null) return button();

    return QueryBuilder(
      query: context.watch<Client>().pools.useGet(id: poolId, vendored: true),
      builder: (context, state) => button(pool: state.data),
    );
  }
}

class _PostPageTitle extends StatelessWidget {
  const _PostPageTitle();

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final params = context.watch<PostParamsController>().value;
    final tags = params.tags ?? '';
    final map = TagMap(tags);

    if (map.isEmpty) {
      return Text(AppLocalizations.of(context).navSearch);
    }
    if (map['order'] == 'rank') {
      return Text(AppLocalizations.of(context).navHot);
    }
    final fav = map['fav'];
    if (fav != null) {
      return Text(
        fav == client.identity.username
            ? AppLocalizations.of(context).navFavorites
            : AppLocalizations.of(context).favoritesOf(fav),
      );
    }

    final fallback = tagToName(map.toString());

    final poolId = params.poolId;
    if (poolId != null) {
      return QueryBuilder(
        query: client.pools.useGet(id: poolId, vendored: true),
        builder: (context, state) =>
            Text(state.data != null ? tagToName(state.data!.name) : fallback),
      );
    }

    return SubFuture<Follow?>(
      keys: [tags, client],
      create: () => client.follows.getByTags(tags: tags),
      builder: (context, snapshot) => Text(snapshot.data?.name ?? fallback),
    );
  }
}
