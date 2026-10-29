import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';

Future<void> showHiddenPostsSheet(BuildContext context, PostFilter filter) {
  final NavigatorState page = Navigator.of(context);
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).canvasColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
    ),
    builder: (context) => HiddenPostsSheet(
      filter: filter,
      onEditBlacklist: () {
        Navigator.of(
          context,
        ).popUntil((route) => route is! ModalBottomSheetRoute);
        page.push(
          MaterialPageRoute(builder: (context) => const DenyListPage()),
        );
      },
    ),
  );
}

class HiddenPostsSheet extends StatelessWidget {
  const HiddenPostsSheet({
    super.key,
    required this.filter,
    required this.onEditBlacklist,
  });

  final PostFilter filter;
  final VoidCallback onEditBlacklist;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MediaQueryData media = MediaQuery.of(context);
    final BorderSide line = BorderSide(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
    );
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: media.size.height - 120),
      child: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: filter,
          builder: (context, child) {
            final Map<String, int> matches = filter.matchCountsByEntry;
            final List<String> entries = matches.keys.toList()
              ..sort((a, b) => matches[b]!.compareTo(matches[a]!));
            final int total = filter.tracked.length;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      width: 32,
                      height: 3,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  decoration: BoxDecoration(border: Border(bottom: line)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text(
                        '${filter.blockedCount} of $total posts hidden',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '${entries.length} blacklist lines matched this search',
                        style: TextStyle(color: dimTextColor(context)),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Opacity(
                    opacity: filter.denying ? 1 : 0.4,
                    child: ListView(
                      primary: false,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      children: [
                        for (final String entry in entries)
                          HiddenPostsLine(
                            entry: entry,
                            count: matches[entry]!,
                            hiding:
                                filter.denying &&
                                !filter.allowedEntries.contains(entry),
                            onChanged: (_) => filter.toggle(entry),
                          ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  decoration: BoxDecoration(border: Border(top: line)),
                  child: Column(
                    spacing: 8,
                    children: [
                      InkWell(
                        onTap: onEditBlacklist,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 48),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Edit blacklist',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Transform.translate(
                                offset: const Offset(4, 0),
                                child: Icon(
                                  Icons.chevron_right,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Use blacklist in this search'),
                        subtitle: const Text(
                          'Off shows every post, for this search only',
                        ),
                        value: filter.denying,
                        onChanged: (value) => filter.denying = value,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class HiddenPostsLine extends StatelessWidget {
  const HiddenPostsLine({
    super.key,
    required this.entry,
    required this.count,
    required this.hiding,
    required this.onChanged,
  });

  final String entry;
  final int count;
  final bool hiding;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<String> tokens = entry.split(' ')..removeWhere((e) => e.isEmpty);
    return InkWell(
      onTap: () => onChanged(!hiding),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            spacing: 12,
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  '$count',
                  textAlign: TextAlign.right,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              Expanded(
                child: ClipRect(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Row(
                      spacing: 10,
                      children: [
                        for (final String token in tokens)
                          DenyToken(token: token),
                      ],
                    ),
                  ),
                ),
              ),
              Switch(value: hiding, onChanged: onChanged),
            ],
          ),
        ),
      ),
    );
  }
}

class DenyToken extends StatelessWidget {
  const DenyToken({super.key, required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    final Color color = switch (token[0]) {
      '-' => Colors.green.shade300,
      '~' => Colors.orange.shade300,
      _ => Colors.red.shade300,
    };
    return Container(
      padding: const EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(width: 2, color: color)),
      ),
      child: Text(
        token.replaceAll('_', ' '),
        maxLines: 1,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontSize: 15, height: 1.2),
      ),
    );
  }
}
