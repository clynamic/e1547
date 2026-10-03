import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/task/task.dart';
import 'package:flutter/material.dart';

List<Widget> taskBulkActions(
  BuildContext context,
  TasksController controller,
  SelectionLayoutData<Task> layoutData,
) {
  final l10n = AppLocalizations.of(context);
  final Set<Task> selected = layoutData.selections;
  final bool hasActive = selected.any((t) => t.status.isActive);
  final bool hasRetryable = selected.any(
    (t) => t.status == TaskStatus.failed || t.status == TaskStatus.canceled,
  );
  final bool hasTerminal = selected.any((t) => t.status.isTerminal);
  return [
    if (hasActive)
      IconButton(
        tooltip: l10n.taskCancel,
        icon: const Icon(Icons.block),
        onPressed: () async {
          for (final t in selected) {
            if (t.status.isActive) {
              await controller.cancel(t.id);
            }
          }
          layoutData.clear();
        },
      ),
    if (hasRetryable)
      IconButton(
        tooltip: l10n.lockRetry,
        icon: const Icon(Icons.refresh),
        onPressed: () async {
          for (final t in selected) {
            if (t.status == TaskStatus.failed ||
                t.status == TaskStatus.canceled) {
              await controller.retry(t.id);
            }
          }
          layoutData.clear();
        },
      ),
    if (hasTerminal)
      IconButton(
        tooltip: l10n.taskDismiss,
        icon: const Icon(Icons.clear_all),
        onPressed: () async {
          for (final t in selected) {
            if (t.status.isTerminal) {
              await controller.dismiss(t.id);
            }
          }
          layoutData.clear();
        },
      ),
  ];
}
