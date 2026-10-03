import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LogSelectionAppBar extends StatelessWidget with AppBarBuilderWidget {
  const LogSelectionAppBar({super.key, required this.child});

  @override
  final PreferredSizeWidget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SelectionAppBar<LogEntry>(
      child: child,
      titleBuilder: (context, data) => data.selections.length == 1
          ? Text(data.selections.first.message, maxLines: 1)
          : Text(l10n.selectionLogsCount(data.selections.length)),
      actionBuilder: (context, data) => [
        IconButton(
          tooltip: l10n.actionCopy,
          icon: const Icon(Icons.copy),
          onPressed: () {
            Clipboard.setData(
              ClipboardData(
                text: data.selections.map(formatLogEntry).join('\n'),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 1),
                content: Text(l10n.copiedToClipboard),
              ),
            );
            data.onChanged({});
          },
        ),
      ],
    );
  }
}

class LogFileSelectionAppBar extends StatelessWidget with AppBarBuilderWidget {
  const LogFileSelectionAppBar({super.key, required this.child, this.onDelete});

  @override
  final PreferredSizeWidget child;
  final ValueSetter<List<LogFileInfo>>? onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SelectionAppBar<LogFileInfo>(
      child: child,
      titleBuilder: (context, data) => data.selections.length == 1
          ? Text(
              l10n.logsTitleDate(
                DateFormatting.date(data.selections.first.date),
              ),
            )
          : Text(l10n.selectionLogsFilesCount(data.selections.length)),
      actionBuilder: (context, data) => [
        if (onDelete != null)
          IconButton(
            tooltip: l10n.menuDelete,
            icon: const Icon(Icons.delete),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => LogFileDeleteConfirmation(
                files: data.selections.toList(),
                onConfirm: () {
                  onDelete?.call(data.selections.toList());
                  data.onChanged({});
                },
              ),
            ),
          ),
      ],
    );
  }
}

class LogFileDeleteConfirmation extends StatelessWidget {
  const LogFileDeleteConfirmation({
    super.key,
    required this.files,
    required this.onConfirm,
  });

  final List<LogFileInfo> files;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.logsDeleteTitle(files.length)),
      content: Text(l10n.actionCannotBeUndone),
      actions: [
        TextButton(
          onPressed: () => popDialog(context),
          child: Text(l10n.actionCancel),
        ),
        TextButton(
          onPressed: () {
            if (popDialog(context)) {
              onConfirm?.call();
            }
          },
          child: Text(l10n.menuDelete),
        ),
      ],
    );
  }
}
