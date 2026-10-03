import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

class LogsDrawer extends StatelessWidget {
  const LogsDrawer({
    super.key,
    required this.levels,
    required this.onChanged,
    this.recording,
    this.verbose = false,
    this.onVerbose,
  });

  final Set<LogLevel> levels;
  final ValueSetter<Set<LogLevel>> onChanged;

  final LogLevel? recording;
  final bool verbose;
  final ValueSetter<bool>? onVerbose;

  void _toggle(LogLevel level, bool enabled) {
    final Set<LogLevel> next = Set.of(levels);
    if (enabled) {
      next.add(level);
    } else {
      next.remove(level);
    }
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final LogLevel? recording = this.recording;
    final ValueSetter<bool>? onVerbose = this.onVerbose;
    final l10n = AppLocalizations.of(context);
    return ContextDrawer(
      title: Text(l10n.logsTitle),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: SectionHeader(
            indent: SectionHeader.listTileIndent,
            title: l10n.logsLevels,
          ),
        ),
        for (final LogLevel level in LogLevel.values)
          if (recording == null || level.isAtLeast(recording))
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: CheckboxListTile(
                secondary: Icon(level.icon),
                title: Text(level.name.pascalCase),
                value: levels.contains(level),
                onChanged: (value) {
                  if (value == null) return;
                  _toggle(level, value);
                },
              ),
            ),
        if (recording != null && onVerbose != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: SectionHeader(
              indent: SectionHeader.listTileIndent,
              title: l10n.logsRecording,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: SwitchListTile(
              secondary: const Icon(Icons.data_object),
              title: Text(l10n.logsVerbose),
              subtitle: Text(
                verbose
                    ? l10n.logsVerboseAll
                    : l10n.logsVerboseMinimum(recording.name.pascalCase),
              ),
              value: verbose,
              onChanged: onVerbose,
            ),
          ),
        ],
      ],
    );
  }
}
