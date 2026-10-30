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
      builder: (context, refreshController) => RefreshShortcuts(
        onRefresh: () async => refreshController.requestRefresh(
          duration: const Duration(milliseconds: 100),
        ),
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
          header: const ClassicHeader(),
          child: child,
        ),
      ),
    );
  }
}

class RefreshShortcuts extends StatefulWidget {
  const RefreshShortcuts({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  State<RefreshShortcuts> createState() => _RefreshShortcutsState();
}

class _RefreshShortcutsState extends State<RefreshShortcuts> {
  Future<void> refresh() => widget.onRefresh();

  bool onKey(KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.f5) {
      refresh();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final NavBarReselectController? reselect = NavBarReselect.maybeOf(context);
    final bool shown =
        TickerMode.valuesOf(context).enabled &&
        (ModalRoute.of(context)?.isCurrent ?? true);
    return SubEffect(
      effect: () {
        if (reselect == null) return null;
        reselect.handler = refresh;
        return () {
          if (reselect.handler == refresh) reselect.handler = null;
        };
      },
      keys: [reselect],
      child: SubEffect(
        effect: () {
          if (!shown) return null;
          HardwareKeyboard.instance.addHandler(onKey);
          return () => HardwareKeyboard.instance.removeHandler(onKey);
        },
        keys: [shown],
        child: widget.child,
      ),
    );
  }
}
