import 'package:e1547/client/client.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';
import 'package:intl/intl.dart';

/// History category names double as stable keys.
///
/// This maps them to their localized display names.
String localizedHistoryCategory(
  BuildContext context,
  HistoryCategory category,
) => switch (category) {
  HistoryCategory.items => AppLocalizations.of(context).historyItems,
  HistoryCategory.searches => AppLocalizations.of(context).historySearches,
};

/// History type names double as stable keys.
///
/// This maps them to their localized display names.
String localizedHistoryType(BuildContext context, HistoryType type) =>
    switch (type) {
      HistoryType.posts => AppLocalizations.of(context).postsTitle,
      HistoryType.pools => AppLocalizations.of(context).navPools,
      HistoryType.topics => AppLocalizations.of(context).topicsTitle,
      HistoryType.wikis => AppLocalizations.of(context).historyWikis,
      HistoryType.users => AppLocalizations.of(context).historyUsers,
    };

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
          title: Text(AppLocalizations.of(context).enabled),
          subtitle: Text(
            AppLocalizations.of(context).pagesVisited(countSnapshot.data ?? 0),
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
      title: Text(AppLocalizations.of(context).historyClear),
      subtitle: Text(AppLocalizations.of(context).historyClearSubtitle),
      leading: const Icon(Icons.clear_all),
      onTap: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context).historyClearConfirm),
          content: Text(AppLocalizations.of(context).historyClearConfirmBody),
          actions: [
            TextButton(
              onPressed: () => popDialog(context),
              child: Text(AppLocalizations.of(context).actionCancel),
            ),
            TextButton(
              onPressed: () {
                if (popDialog(context)) {
                  client.histories.useClear().mutate();
                }
              },
              child: Text(AppLocalizations.of(context).historyClearAction),
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
                title: Text(AppLocalizations.of(context).historyLimit),
                content: Text(
                  AppLocalizations.of(context).historyLimitEnableBody(
                    NumberFormat.compact().format(trimAmount),
                    trimAge.inDays ~/ 30,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => popDialog(context),
                    child: Text(AppLocalizations.of(context).actionCancel),
                  ),
                  TextButton(
                    onPressed: () {
                      if (popDialog(context)) {
                        client.traits.value = client.traits.value.copyWith(
                          trimHistory: value,
                        );
                      }
                    },
                    child: Text(AppLocalizations.of(context).actionOk),
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
        title: Text(AppLocalizations.of(context).historyLimitTitle),
        subtitle: (traits.trimHistory ?? false)
            ? Text(
                AppLocalizations.of(context).historyLimitOn(
                  NumberFormat.compact().format(trimAmount),
                  trimAge.inDays ~/ 30,
                ),
              )
            : Text(AppLocalizations.of(context).historyLimitOff),
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
              title: AppLocalizations.of(context).historyEntries,
            ),
          ),
          for (final filter in HistoryCategory.values)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: CheckboxListTile(
                secondary: filter.icon,
                title: Text(localizedHistoryCategory(context, filter)),
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
              title: AppLocalizations.of(context).historyType,
            ),
          ),
          for (final filter in HistoryType.values)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: CheckboxListTile(
                secondary: filter.icon,
                title: Text(localizedHistoryType(context, filter)),
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
