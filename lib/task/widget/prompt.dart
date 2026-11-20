import 'package:e1547/shared/shared.dart';
import 'package:e1547/task/task.dart';
import 'package:flutter/material.dart';

Future<void> showTasksPrompt(BuildContext context) => showSliverPrompt<void>(
  context,
  parentBuilder: (context, child) => TasksListProvider(
    child: Consumer<TasksListController>(
      builder: (context, listController, _) => SelectionLayout<Task>(
        items: listController.items ?? const [],
        keyOf: (task) => task.id,
        child: child,
      ),
    ),
  ),
  header: (context) =>
      _PromptHeader(controller: context.read<TasksController>()),
  sliver: const SliverTasksList(),
);

class _PromptHeader extends StatelessWidget {
  const _PromptHeader({required this.controller});

  final TasksController controller;

  @override
  Widget build(BuildContext context) {
    final layoutData = SelectionLayout.of<Task>(context);
    final selecting = layoutData.selections.isNotEmpty;
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: selecting
            ? _SelectionBar(
                key: const ValueKey('select'),
                layoutData: layoutData,
                controller: controller,
              )
            : _GlobalActionsBar(
                key: const ValueKey('actions'),
                layoutData: layoutData,
                controller: controller,
              ),
      ),
    );
  }
}

class _GlobalActionsBar extends StatelessWidget {
  const _GlobalActionsBar({
    super.key,
    required this.layoutData,
    required this.controller,
  });

  final SelectionLayoutData<Task> layoutData;
  final TasksController controller;

  @override
  Widget build(BuildContext context) {
    final bool hasActive = layoutData.items.any((t) => t.status.isActive);
    final bool hasDone = layoutData.items.any(
      (t) =>
          t.status == TaskStatus.completed || t.status == TaskStatus.canceled,
    );
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Tasks',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Spacer(),
            if (hasActive)
              ActionButton(
                icon: const Icon(Icons.block),
                label: const Text('Cancel all'),
                onTap: controller.cancelAll,
              ),
            if (hasDone)
              ActionButton(
                icon: const Icon(Icons.delete_sweep),
                label: const Text('Clear done'),
                onTap: controller.clearDone,
              ),
          ],
        ),
      ),
    );
  }
}

class _SelectionBar extends StatelessWidget {
  const _SelectionBar({
    super.key,
    required this.layoutData,
    required this.controller,
  });

  final SelectionLayoutData<Task> layoutData;
  final TasksController controller;

  @override
  Widget build(BuildContext context) {
    final Set<Task> selected = layoutData.selections;
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            IconButton(
              tooltip: 'clear selection',
              icon: const Icon(Icons.close),
              onPressed: layoutData.clear,
            ),
            Text(
              '${selected.length} selected',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            IconButton(
              tooltip: 'select all',
              icon: const Icon(Icons.select_all),
              onPressed: layoutData.selectAll,
            ),
            ...taskBulkActions(controller, layoutData),
          ],
        ),
      ),
    );
  }
}
