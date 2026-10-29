import 'package:e1547/app/app.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/task/task.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppBubbleOverlay extends StatefulWidget {
  const AppBubbleOverlay({
    super.key,
    required this.child,
    required this.navigatorKey,
  });

  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<AppBubbleOverlay> createState() => _AppBubbleOverlayState();
}

class _AppBubbleOverlayState extends State<AppBubbleOverlay> {
  final Set<Object> _open = {};

  Future<void> _prompt(Object id, Future<void> Function() show) async {
    if (_open.contains(id)) return;
    setState(() => _open.add(id));
    try {
      await show();
    } finally {
      if (mounted) setState(() => _open.remove(id));
    }
  }

  void _openLogs() => context.read<ShellController>().navigator?.push(
    MaterialPageRoute(builder: (context) => const LogsPage()),
  );

  @override
  Widget build(BuildContext context) {
    final TasksController tasks = context.watch<TasksController>();
    final LogErrors? errors = kDebugMode ? context.watch<LogErrors?>() : null;

    return ListenableBuilder(
      listenable: Listenable.merge([
        tasks.suppressBubble,
        errors?.suppressBubble,
      ]),
      builder: (context, _) => BubbleOverlay(
        side: Handedness.of(context).side,
        bubbles: [
          if (_open.isEmpty) ...[
            if (tasks.kind != TaskKind.none && !tasks.suppressBubble.value)
              OverlayBubble(
                id: 'tasks',
                size: TaskBubble.size,
                child: TaskBubble(
                  onTap: () => _prompt('tasks', () async {
                    final BuildContext? target =
                        widget.navigatorKey.currentContext;
                    if (target == null) return;
                    await showTasksPrompt(target);
                  }),
                ),
              ),
            if (errors != null &&
                !errors.isEmpty &&
                !errors.suppressBubble.value)
              OverlayBubble(
                id: 'errors',
                size: LogErrorBubble.size,
                child: LogErrorBubble(
                  onTap: () => _prompt('errors', () async {
                    final BuildContext? target =
                        widget.navigatorKey.currentContext;
                    if (target == null) return;
                    await showLogErrorsPrompt(
                      target,
                      errors: errors,
                      onOpenLogs: _openLogs,
                    );
                  }),
                ),
              ),
          ],
        ],
        child: widget.child,
      ),
    );
  }
}
