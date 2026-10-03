import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/reply/reply.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class ReplyListDrawer extends StatelessWidget {
  const ReplyListDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ReplyParamsController>();
    final l10n = AppLocalizations.of(context);
    return ContextDrawer(
      title: Text(l10n.repliesTitle),
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.sort),
          title: Text(l10n.replyOrder),
          subtitle: Text(switch (controller.value.order) {
            ReplyOrder.oldest => l10n.filterOldestFirst,
            ReplyOrder.newest => l10n.filterNewestFirst,
          }),
          value: controller.value.order == ReplyOrder.oldest,
          onChanged: (value) {
            controller.update(
              (p) => p.copyWith(
                order: value ? ReplyOrder.oldest : ReplyOrder.newest,
              ),
            );
            Scaffold.of(context).closeEndDrawer();
          },
        ),
      ],
    );
  }
}
