import 'package:e1547/client/client.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';
import 'package:intl/intl.dart';

class HistoryEnableTile extends StatelessWidget {
  const HistoryEnableTile({super.key});

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return SubStream<int>(
      create: () => client.histories.count().streamed,
      keys: [client],
      builder: (context, countSnapshot) => ValueListenableBuilder(
        valueListenable: client.traits,
        builder: (context, traits, child) => SwitchListTile(
          title: Text(t('Enabled')),
          subtitle: Text(
            tf('{n} pages visited', params: {'n': countSnapshot.data ?? 0}),
          ),
          secondary: const Icon(Icons.history),
          value: traits.writeHistory ?? true,
          onChanged: (value) => client.traits.value = client.traits.value
              .copyWith(writeHistory: value),
        ),
      ),
    );
  }
}

class HistoryClearTile extends StatelessWidget {
  const HistoryClearTile({super.key});

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return ListTile(
      title: Text(t('Clear history')),
      subtitle: Text(t('Delete all entries')),
      leading: const Icon(Icons.clear_all),
      onTap: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(t('Clear history?')),
          content: Text(
            t(
              'All history entries will be permanently deleted. This action cannot be undone.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t('Cancel')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                client.histories.useClear().mutate();
              },
              child: Text(t('Clear')),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryLimitTile extends StatelessWidget {
  const HistoryLimitTile({super.key});

  static const int trimAmount = 5000;
  static const Duration trimAge = Duration(days: 30 * 3);

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return ValueListenableBuilder(
      valueListenable: client.traits,
      builder: (context, traits, child) => SwitchListTile(
        value: traits.trimHistory ?? false,
        onChanged: (value) {
          if (value) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(t('History limit')),
                content: Text(
                  tf(
                    'Enabling history limit means all history entries beyond {amount} '
                    'and all entries older than {months} months are automatically deleted.',
                    params: {
                      'amount': NumberFormat.compact().format(trimAmount),
                      'months': trimAge.inDays ~/ 30,
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: Text(t('CANCEL')),
                  ),
                  TextButton(
                    onPressed: () {
                      client.traits.value = client.traits.value.copyWith(
                        trimHistory: value,
                      );
                      Navigator.of(context).maybePop();
                    },
                    child: Text(t('OK')),
                  ),
                ],
              ),
            );
          } else {
            client.traits.value = client.traits.value.copyWith(
              trimHistory: value,
            );
          }
        },
        secondary: Icon(
          (traits.trimHistory ?? false)
              ? Icons.hourglass_bottom
              : Icons.hourglass_empty,
        ),
        title: Text(t('Limit history')),
        subtitle: (traits.trimHistory ?? false)
            ? Text(
                tf(
                  'Limited to newer than {months} months or '
                  'less than {amount} entries.',
                  params: {
                    'months': trimAge.inDays ~/ 30,
                    'amount': NumberFormat.compact().format(trimAmount),
                  },
                ),
              )
            : Text(t('history is infinite')),
      ),
    );
  }
}

class HistoryCategoryFilterTile extends StatelessWidget {
  const HistoryCategoryFilterTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryParamsController>(
      builder: (context, controller, _) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: SectionHeader(
              indent: SectionHeader.listTileIndent,
              title: t('Entries'),
            ),
          ),
          for (final filter in HistoryCategory.values)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: CheckboxListTile(
                secondary: filter.icon,
                title: Text(t(filter.title)),
                value: controller.value.categories?.contains(filter) ?? true,
                onChanged: (value) {
                  if (value == null) return;
                  controller.update((p) {
                    final filters =
                        p.categories?.toSet() ?? HistoryCategory.values.toSet();
                    if (value) {
                      filters.add(filter);
                    } else {
                      filters.remove(filter);
                    }
                    return p.copyWith(categories: filters);
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}

class HistoryTypeFilterTile extends StatelessWidget {
  const HistoryTypeFilterTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryParamsController>(
      builder: (context, controller, _) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: SectionHeader(
              indent: SectionHeader.listTileIndent,
              title: t('Type'),
            ),
          ),
          for (final filter in HistoryType.values)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: CheckboxListTile(
                secondary: filter.icon,
                title: Text(t(filter.title)),
                value: controller.value.types?.contains(filter) ?? true,
                onChanged: (value) {
                  if (value == null) return;
                  controller.update((p) {
                    final filters =
                        p.types?.toSet() ?? HistoryType.values.toSet();
                    if (value) {
                      filters.add(filter);
                    } else {
                      filters.remove(filter);
                    }
                    return p.copyWith(types: filters);
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
