import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/task/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TasksController controller = context.read<TasksController>();
    return TasksListProvider(
      child: Consumer<TasksListController>(
        builder: (context, listController, _) {
          final List<Task> items = listController.items ?? const [];
          final bool hasActive = items.any((t) => t.status.isActive);
          final bool hasDone = items.any(
            (t) =>
                t.status == TaskStatus.completed ||
                t.status == TaskStatus.canceled,
          );
          return _SuppressBubbleWhileMounted(
            controller: controller,
            child: SelectionLayout<Task>(
              items: items,
              child: AdaptiveScaffold(
                appBar: SelectionAppBar<Task>(
                  titleBuilder: (context, layoutData) => Text(
                    AppLocalizations.of(
                      context,
                    ).taskSelectionCount(layoutData.selections.length),
                  ),
                  actionBuilder: (context, layoutData) =>
                      taskBulkActions(context, controller, layoutData),
                  child: DefaultAppBar(
                    title: Text(AppLocalizations.of(context).navTasks),
                    actions: [
                      if (hasActive)
                        IconButton(
                          tooltip: AppLocalizations.of(context).taskCancelAll,
                          icon: const Icon(Icons.block),
                          onPressed: controller.cancelAll,
                        ),
                      if (hasDone)
                        IconButton(
                          tooltip: AppLocalizations.of(context).taskClearDone,
                          icon: const Icon(Icons.delete_sweep),
                          onPressed: controller.clearDone,
                        ),
                    ],
                  ),
                ),
                drawer: const RouterDrawer(),
                body: const CustomScrollView(
                  primary: true,
                  slivers: [SliverTasksList()],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SuppressBubbleWhileMounted extends StatelessWidget {
  const _SuppressBubbleWhileMounted({
    required this.controller,
    required this.child,
  });

  final TasksController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SubEffect(
      effect: () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => controller.suppressBubble.value = true,
        );
        return () => WidgetsBinding.instance.addPostFrameCallback(
          (_) => controller.suppressBubble.value = false,
        );
      },
      keys: [controller],
      child: child,
    );
  }
}
