import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/task/task.dart';
import 'package:flutter/material.dart';

String _groupOf(Task task) {
  if (task.status.isActive) return 'active';
  if (task.status == TaskStatus.failed) return 'failed';
  return 'done';
}

int _groupOrder(String group) => switch (group) {
  'active' => 0,
  'failed' => 1,
  _ => 2,
};

int _groupComparator(String a, String b) =>
    _groupOrder(a).compareTo(_groupOrder(b));

int _itemComparator(Task a, Task b) {
  if (_groupOf(a) == 'active') {
    final int byTime = a.createdAt.compareTo(b.createdAt);
    if (byTime != 0) return byTime;
    return a.id.compareTo(b.id);
  }
  final int byTime = b.createdAt.compareTo(a.createdAt);
  if (byTime != 0) return byTime;
  return b.id.compareTo(a.id);
}

/// Task group names double as grouping keys.
///
/// This maps them to their localized display names.
String localizedTaskGroupName(BuildContext context, String group) {
  final l10n = AppLocalizations.of(context);
  return switch (group) {
    'active' => l10n.taskGroupActive,
    'failed' => l10n.taskGroupFailed,
    _ => l10n.taskDone,
  };
}

class TasksListView extends StatelessWidget {
  const TasksListView({super.key});

  @override
  Widget build(BuildContext context) =>
      const CustomScrollView(slivers: [SliverTasksList()]);
}

class SliverTasksList extends StatelessWidget {
  const SliverTasksList({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final TasksListController controller = context.watch<TasksListController>();
    final SelectionLayoutData<Task> layoutData = SelectionLayout.of<Task>(
      context,
    );
    return PagedSliverGroupedListView<int, Task, String>(
      state: controller.state,
      fetchNextPage: () {},
      groupBy: _groupOf,
      groupComparator: _groupComparator,
      itemComparator: _itemComparator,
      groupSeparatorBuilder: (value) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: SectionHeader(title: localizedTaskGroupName(context, value)),
      ),
      builderDelegate: defaultPagedChildBuilderDelegate<Task>(
        onRetry: () {},
        onEmpty: Text(l10n.taskNoTasks),
        onError: Text(l10n.taskFailedToLoadTasks),
        itemBuilder: (context, task, index) => TaskTile(
          task: task,
          controller: context.read<TasksController>(),
          layoutData: layoutData,
        ),
      ),
    );
  }
}
