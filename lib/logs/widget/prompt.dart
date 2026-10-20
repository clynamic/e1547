import 'package:e1547/logs/logs.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

Future<void> showLogErrorsPrompt(
  BuildContext context, {
  required LogErrors errors,
  VoidCallback? onOpenLogs,
}) => showSliverPrompt<void>(
  context,
  parentBuilder: (context, child) => Expandables(child: child),
  dialogConstraints: const BoxConstraints(minHeight: 200, maxHeight: 400),
  header: (context) => LogErrorsHeader(errors: errors, onOpenLogs: onOpenLogs),
  sliver: LogErrorsSliver(errors: errors),
);

class LogErrorsSliver extends StatelessWidget {
  const LogErrorsSliver({super.key, required this.errors});

  final LogErrors errors;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: errors,
    builder: (context, _) {
      final List<LogEntry> items = errors.errors;
      if (items.isEmpty) {
        return SliverToBoxAdapter(
          child: IconMessage(
            icon: const Icon(Icons.check),
            title: Text(t('No errors logged')),
          ),
        );
      }
      return SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        sliver: SliverList.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => LogEntryTile(item: items[index]),
        ),
      );
    },
  );
}

class LogErrorsHeader extends StatelessWidget {
  const LogErrorsHeader({super.key, required this.errors, this.onOpenLogs});

  final LogErrors errors;
  final VoidCallback? onOpenLogs;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: errors,
      builder: (context, _) => SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  logErrorsTitle(errors.length),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Spacer(),
              if (onOpenLogs != null)
                ActionButton(
                  icon: const Icon(Icons.format_list_numbered),
                  label: Text(t('All logs')),
                  onTap: () {
                    Navigator.of(context).pop();
                    onOpenLogs!();
                  },
                ),
              if (!errors.isEmpty)
                ActionButton(
                  icon: const Icon(Icons.delete_sweep),
                  label: Text(t('Dismiss all')),
                  onTap: () {
                    errors.clear();
                    Navigator.of(context).pop();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

String logErrorsTitle(int count) =>
    count == 1 ? t('1 error') : tf('{n} errors', params: {'n': count});
