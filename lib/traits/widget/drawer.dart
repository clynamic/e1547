import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

class DrawerDenySwitch extends StatelessWidget {
  const DrawerDenySwitch({super.key, this.filter});

  final PostFilter? filter;

  @override
  Widget build(BuildContext context) {
    final resolved = filter ?? context.watch<PostFilter>();
    return AnimatedBuilder(
      animation: resolved,
      builder: (context, child) => DrawerDenySwitchBody(
        denying: resolved.denying,
        blockedCount: resolved.blockedCount,
        entryCounts: resolved.blockedCountsByEntry,
        updateAllowedList: (value) => resolved.allowedEntries = value,
        updateDenying: (value) => resolved.denying = value,
        allowedList: resolved.allowedEntries,
      ),
    );
  }
}

class DrawerDenyTile extends StatelessWidget {
  const DrawerDenyTile({
    super.key,
    required this.entry,
    required this.count,
    required this.isAllowed,
    required this.onChanged,
  });

  final bool isAllowed;
  final int count;
  final void Function(bool? value) onChanged;
  final String entry;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: isAllowed,
      onChanged: onChanged,
      title: Row(
        children: [
          Expanded(
            child: Wrap(
              children: entry
                  .split(' ')
                  .where((tag) => tag.isNotEmpty)
                  .map(DenyListTagCard.new)
                  .toList(),
            ),
          ),
        ],
      ),
      secondary: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 24),
        child: TweenAnimationBuilder(
          tween: IntTween(begin: 0, end: count),
          duration: const Duration(milliseconds: 200),
          builder: (context, value, child) => Text(
            value.toString(),
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class DrawerDenySwitchBody extends StatelessWidget {
  const DrawerDenySwitchBody({
    super.key,
    required this.denying,
    required this.blockedCount,
    required this.entryCounts,
    required this.allowedList,
    required this.updateDenying,
    required this.updateAllowedList,
  });

  final bool denying;
  final int blockedCount;
  final Map<String, int> entryCounts;
  final List<String> allowedList;

  final ValueChanged<bool> updateDenying;
  final ValueChanged<List<String>> updateAllowedList;

  @override
  Widget build(BuildContext context) {
    final entries = <String, int>{
      ...entryCounts,
      for (final e in allowedList) e: entryCounts[e] ?? 0,
    };
    final sortedKeys = entries.keys.toList()..sort();

    return Column(
      children: [
        SwitchListTile(
          title: Text(AppLocalizations.of(context).settingsBlacklist),
          subtitle: denying && blockedCount > 0
              ? TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: blockedCount),
                  duration: defaultAnimationDuration,
                  builder: (context, value, child) =>
                      Text(AppLocalizations.of(context).postsBlocked(value)),
                )
              : null,
          secondary: const Icon(Icons.block),
          value: denying,
          onChanged: updateDenying,
        ),
        CrossFade(
          showChild: entries.isNotEmpty,
          child: Column(
            children: [
              const Divider(),
              ...sortedKeys.map(
                (key) => DrawerDenyTile(
                  entry: key,
                  count: entries[key] ?? 0,
                  isAllowed: !allowedList.contains(key),
                  onChanged: (value) {
                    final allowed = List<String>.from(allowedList);
                    if (value!) {
                      allowed.remove(key);
                    } else {
                      allowed.add(key);
                    }
                    updateAllowedList(allowed);
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
