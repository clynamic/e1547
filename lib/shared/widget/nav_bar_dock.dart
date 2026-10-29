import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class NavBarDocks extends ChangeNotifier {
  final Map<Object, ({double share, WidgetBuilder builder})> _docks = {};

  WidgetBuilder? get current {
    ({double share, WidgetBuilder builder})? best;
    for (final entry in _docks.values) {
      if (entry.share < 0.5) continue;
      if (best == null || entry.share > best.share) best = entry;
    }
    return best?.builder;
  }

  void dock(Object owner, double share, WidgetBuilder builder) {
    final WidgetBuilder? before = current;
    if (share <= 0) {
      _docks.remove(owner);
    } else {
      _docks[owner] = (share: share, builder: builder);
    }
    if (current != before) _announce();
  }

  void _announce() {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!_disposed) notifyListeners();
      });
      return;
    }
    notifyListeners();
  }

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class NavBarDockScope extends InheritedWidget {
  const NavBarDockScope({super.key, required this.docks, required super.child});

  final NavBarDocks docks;

  static NavBarDocks? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<NavBarDockScope>()?.docks;

  @override
  bool updateShouldNotify(NavBarDockScope oldWidget) =>
      oldWidget.docks != docks;
}

class NavBarDock extends StatefulWidget {
  const NavBarDock({super.key, required this.builder, required this.child});

  final WidgetBuilder builder;
  final Widget child;

  @override
  State<NavBarDock> createState() => _NavBarDockState();
}

class _NavBarDockState extends State<NavBarDock> {
  NavBarDocks? _docks;
  ModalRoute<Object?>? _route;

  void _onMove() {
    final ModalRoute<Object?>? route = _route;
    if (route == null) return;
    final double shown = route.animation?.value ?? 1;
    final double covered = route.secondaryAnimation?.value ?? 0;
    _docks?.dock(this, shown * (1 - covered), widget.builder);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _docks ??= NavBarDockScope.maybeOf(context);
    final ModalRoute<Object?>? now = ModalRoute.of(context);
    if (now == _route) return;
    _route?.animation?.removeListener(_onMove);
    _route?.secondaryAnimation?.removeListener(_onMove);
    _route = now;
    _route?.animation?.addListener(_onMove);
    _route?.secondaryAnimation?.addListener(_onMove);
    _onMove();
  }

  @override
  void didUpdateWidget(covariant NavBarDock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.builder != widget.builder) _onMove();
  }

  @override
  void dispose() {
    _route?.animation?.removeListener(_onMove);
    _route?.secondaryAnimation?.removeListener(_onMove);
    _docks?.dock(this, 0, widget.builder);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
