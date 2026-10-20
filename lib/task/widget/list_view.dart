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
        child: SectionHeader(title: t(value)),
      ),
      builderDelegate: defaultPagedChildBuilderDelegate<Task>(
        onRetry: () {},
        onEmpty: Text(t('No tasks')),
        onError: Text(t('Failed to load tasks')),
        itemBuilder: (context, task, index) => TaskTile(
          task: task,
          controller: context.read<TasksController>(),
          layoutData: layoutData,
        ),
      ),
    );
  }
}
