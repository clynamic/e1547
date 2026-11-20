import 'package:e1547/shared/shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sub/flutter_sub.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PullToRefresh extends StatelessWidget {
  const PullToRefresh({
    super.key,
    required this.child,
    required Future<void> Function() this.onRefresh,
  }) : onNotedRefresh = null;

  const PullToRefresh.noted({
    super.key,
    required this.child,
    required Future<Widget?> Function() onRefresh,
  }) : onNotedRefresh = onRefresh,
       onRefresh = null;

  final Widget child;
  final Future<void> Function()? onRefresh;
  final Future<Widget?> Function()? onNotedRefresh;

  @override
  Widget build(BuildContext context) {
    return SubValue<ValueNotifier<Widget?>>(
      create: () => ValueNotifier(null),
      dispose: (value) => value.dispose(),
      builder: (context, note) => SubValue(
        create: () => RefreshController(),
        builder: (context, refreshController) => SubEffect(
          effect: () {
            bool handler(KeyEvent event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.f5 &&
                  (ModalRoute.isCurrentOf(context) ?? true)) {
                refreshController.requestRefresh(
                  duration: const Duration(milliseconds: 100),
                );
                return true;
              }
              return false;
            }

            HardwareKeyboard.instance.addHandler(handler);
            return () => HardwareKeyboard.instance.removeHandler(handler);
          },
          keys: const [],
          child: SmartRefresher(
            controller: refreshController,
            onRefresh: () async {
              try {
                await onRefresh?.call();
                note.value = await onNotedRefresh?.call();
                if (note.value != null) {
                  await WidgetsBinding.instance.endOfFrame;
                }
                refreshController.refreshCompleted();
              } on Object {
                note.value = null;
                refreshController.refreshFailed();
              }
            },
            header: HexagonRefreshHeader(note: note),
            child: child,
          ),
        ),
      ),
    );
  }
}

const double _refreshExtent = 64;

class HexagonRefreshHeader extends StatefulWidget {
  const HexagonRefreshHeader({super.key, this.note});

  final ValueListenable<Widget?>? note;

  @override
  State<HexagonRefreshHeader> createState() => _HexagonRefreshHeaderState();
}

class _HexagonRefreshHeaderState extends State<HexagonRefreshHeader> {
  final ValueNotifier<double> pull = ValueNotifier(0);

  @override
  void dispose() {
    pull.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<Widget?>(
    valueListenable: widget.note ?? const AlwaysStoppedAnimation(null),
    builder: (context, note, child) => CustomHeader(
      height: _refreshExtent,
      completeDuration: Duration(milliseconds: note == null ? 600 : 1400),
      onOffsetChange: (offset) => pull.value = offset,
      builder: (context, status) => SizedBox(
        height: _refreshExtent,
        child: Center(
          child: switch (status) {
            RefreshStatus.completed when note != null => note,
            _ => ValueListenableBuilder<double>(
              valueListenable: pull,
              builder: (context, offset, child) => HexagonalLoadingIndicator(
                state: switch (status) {
                  RefreshStatus.refreshing => HexagonState.loading,
                  RefreshStatus.canRefresh ||
                  RefreshStatus.completed ||
                  RefreshStatus.failed => HexagonState.armed,
                  _ => HexagonState.tracing,
                },
                progress: (offset / _refreshExtent).clamp(0, 1),
              ),
            ),
          },
        ),
      ),
    ),
  );
}

class RefreshNote extends StatelessWidget {
  const RefreshNote(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: TextStyle(fontSize: 14, color: dimTextColor(context)));
}
