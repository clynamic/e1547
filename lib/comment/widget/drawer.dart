import 'package:e1547/comment/comment.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class CommentListDrawer extends StatelessWidget {
  const CommentListDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CommentParamsController>();
    final l10n = AppLocalizations.of(context);
    return ContextDrawer(
      title: Text(l10n.commentsTitle),
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.sort),
          title: Text(l10n.commentOrder),
          subtitle: Text(switch (controller.value.order) {
            CommentOrder.oldest => l10n.filterOldestFirst,
            CommentOrder.newest => l10n.filterNewestFirst,
          }),
          value: controller.value.order == CommentOrder.oldest,
          onChanged: (value) {
            controller.update(
              (p) => p.copyWith(
                order: value ? CommentOrder.oldest : CommentOrder.newest,
              ),
            );
            Scaffold.of(context).closeEndDrawer();
          },
        ),
      ],
    );
  }
}
