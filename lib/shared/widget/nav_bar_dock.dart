import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class NavBarDocks extends ChangeNotifier {
  final Map<Object, ({double share, WidgetBuilder builder, bool full})> _docks =
      {};

  ({double share, WidgetBuilder builder, bool full})? get _best {
    ({double share, WidgetBuilder builder, bool full})? best;
    for (final entry in _docks.values) {
      if (entry.share < 0.5) continue;
      if (best == null || entry.share > best.share) best = entry;
    }
    return best;
  }

  WidgetBuilder? get current => _best?.builder;

  final _DockContent _content = _DockContent();

  Listenable get content => _content;

  bool get full => _best?.full ?? false;

  void dock(
    Object owner,
    double share,
    WidgetBuilder builder, {
    bool full = false,
  }) {
    final WidgetBuilder? before = current;
    final bool wasFull = this.full;
    if (share <= 0) {
      _docks.remove(owner);
    } else {
      _docks[owner] = (share: share, builder: builder, full: full);
    }
    _changed(before, wasFull);
  }

  void undock(Object owner) {
    final WidgetBuilder? before = current;
    final bool wasFull = full;
    _docks.remove(owner);
    _changed(before, wasFull);
  }

  void _changed(WidgetBuilder? before, bool wasFull) {
    if ((current == null) != (before == null) || full != wasFull) {
      _announce(notifyListeners);
    } else if (current != before) {
      _announce(_content.changed);
    }
  }

  void _announce(VoidCallback notify) {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!_disposed) notify();
      });
      return;
    }
    notify();
  }

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    _content.dispose();
    super.dispose();
  }
}

class _DockContent extends ChangeNotifier {
  void changed() => notifyListeners();
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
  const NavBarDock({
    super.key,
    required this.builder,
    required this.child,
    this.full = false,
  });

  final WidgetBuilder? builder;
  final Widget child;
  final bool full;

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
    final WidgetBuilder? builder = widget.builder;
    if (builder == null) {
      _docks?.undock(this);
      return;
    }
    _docks?.dock(this, shown * (1 - covered), builder, full: widget.full);
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
    if (oldWidget.builder != widget.builder || oldWidget.full != widget.full) {
      _onMove();
    }
  }

  @override
  void dispose() {
    _route?.animation?.removeListener(_onMove);
    _route?.secondaryAnimation?.removeListener(_onMove);
    _docks?.undock(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
