import 'package:e1547/reply/reply.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class ReplyListDrawer extends StatelessWidget {
  const ReplyListDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ReplyParamsController>();
    return ContextDrawer(
      title: Text(t('Replies')),
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.sort),
          title: Text(t('Reply order')),
          subtitle: Text(
            t(switch (controller.value.order) {
              ReplyOrder.oldest => 'oldest first',
              ReplyOrder.newest => 'newest first',
            }),
          ),
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
