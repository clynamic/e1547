import 'package:e1547/client/client.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class HistoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HistoryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HistoryParamsController>();
    final date = controller.value.date;

    return HistorySelectionAppBar(
      child: DefaultAppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context).navHistory),
            CrossFade.builder(
              showChild: date != null,
              builder: (context) => Text(
                localizedDateName(context, date!),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).textTheme.bodySmall!.color,
                ),
              ),
            ),
          ],
        ),
        actions: const [ContextDrawerButton()],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class HistorySelectionAppBar extends StatelessWidget with AppBarBuilderWidget {
  const HistorySelectionAppBar({super.key, required this.child});

  @override
  final PreferredSizeWidget child;

  @override
  Widget build(BuildContext context) {
    return SelectionAppBar<History>(
      child: child,
      titleBuilder: (context, data) => data.selections.length == 1
          ? Text(data.selections.first.getName(context))
          : Text(
              AppLocalizations.of(
                context,
              ).historySelectionCount(data.selections.length),
            ),
      actionBuilder: (context, data) => [
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () async {
            final client = context.read<Client>();
            final l10n = AppLocalizations.of(context);
            final messenger = ScaffoldMessenger.of(context);
            final selections = List.of(data.selections);
            final removeMutation = client.histories.useRemove();
            data.onChanged({});
            await removeMutation.mutate(selections.map((e) => e.id).toList());
            messenger.showSnackBar(
              SnackBar(
                content: Text(l10n.historyEntriesDeleted(selections.length)),
                action: SnackBarAction(
                  label: l10n.actionUndo,
                  onPressed: () {
                    for (final entry in selections) {
                      client.histories.useAdd().mutate(
                        HistoryRequest(
                          visitedAt: entry.visitedAt,
                          link: entry.link,
                          category: entry.category,
                          type: entry.type,
                          title: entry.title,
                          subtitle: entry.subtitle,
                          thumbnails: entry.thumbnails,
                        ),
                      );
                    }
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
