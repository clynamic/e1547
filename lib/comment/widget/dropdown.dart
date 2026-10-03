import 'package:e1547/client/client.dart';
import 'package:e1547/comment/comment.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class CommentListDropdown extends StatelessWidget {
  const CommentListDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final controller = context.watch<CommentParamsController>();
    final query = client.comments.usePage(query: controller.value.toQuery());
    final postId = controller.value.postId;
    final l10n = AppLocalizations.of(context);

    return PopupMenuButton<VoidCallback>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) => value(),
      itemBuilder: (context) => [
        PopupMenuTile(
          title: l10n.menuRefresh,
          icon: Icons.refresh,
          value: () => query.invalidate(),
        ),
        PopupMenuTile(
          icon: Icons.sort,
          title: controller.value.order == CommentOrder.oldest
              ? l10n.filterNewestFirst
              : l10n.filterOldestFirst,
          value: () => controller.update(
            (p) => p.copyWith(
              order: p.order == CommentOrder.oldest
                  ? CommentOrder.newest
                  : CommentOrder.oldest,
            ),
          ),
        ),
        if (postId != null)
          PopupMenuTile(
            title: l10n.menuComment,
            icon: Icons.comment,
            value: () => guardWithLogin(
              context: context,
              callback: () async {
                bool success = await writeComment(
                  context: context,
                  postId: postId,
                );
                if (success) {
                  query.invalidate();
                }
              },
              error: l10n.loginRequiredComment,
            ),
          ),
      ],
    );
  }
}
