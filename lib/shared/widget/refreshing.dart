import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sub/flutter_sub.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PullToRefresh extends StatelessWidget {
  const PullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  final Widget child;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return SubValue(
      create: () => RefreshController(),
      builder: (context, refreshController) => SubEffect(
        effect: () {
          bool handler(KeyEvent event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.f5) {
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
              await onRefresh();
              refreshController.refreshCompleted();
            } on Object {
              refreshController.refreshFailed();
            }
          },
          header: const HexagonRefreshHeader(),
          child: child,
        ),
      ),
    );
  }
}

const double _refreshExtent = 64;

class HexagonRefreshHeader extends StatefulWidget {
  const HexagonRefreshHeader({super.key});

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
  Widget build(BuildContext context) => CustomHeader(
    height: _refreshExtent,
    onOffsetChange: (offset) => pull.value = offset,
    builder: (context, status) => SizedBox(
      height: _refreshExtent,
      child: Center(
        child: ValueListenableBuilder<double>(
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
      ),
    ),
  );
}
