import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class NavBarCover extends ChangeNotifier {
  final Map<Object, double> _shares = {};

  double get coverage => _shares.values.fold(0, math.max);

  bool get covered => coverage > 0;

  void cover(Object owner, double share) {
    final double before = coverage;
    if (share <= 0) {
      _shares.remove(owner);
    } else {
      _shares[owner] = share.clamp(0, 1);
    }
    if (coverage != before) _announce();
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

class NavBarInset extends InheritedWidget {
  const NavBarInset({super.key, required this.space, required super.child});

  final double space;

  static double of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NavBarInset>()?.space ?? 0;

  @override
  bool updateShouldNotify(NavBarInset oldWidget) => oldWidget.space != space;
}

class NavBarPadding extends StatelessWidget {
  const NavBarPadding({super.key, required this.space, required this.child});

  final double space;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(
        padding: media.padding.copyWith(
          bottom:
              media.padding.bottom +
              math.max(0, space - media.viewInsets.bottom),
        ),
        viewPadding: media.viewPadding.copyWith(
          bottom: media.viewPadding.bottom + space,
        ),
      ),
      child: NavBarInset(space: space, child: child),
    );
  }
}

class NavBarCoveredPadding extends StatelessWidget {
  const NavBarCoveredPadding({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double space = NavBarInset.of(context);
    if (space == 0) return child;
    return NavBarInset(
      space: 0,
      child: MediaQuery(
        data: media.copyWith(
          padding: media.padding.copyWith(
            bottom: math.max(0, media.padding.bottom - space),
          ),
          viewPadding: media.viewPadding.copyWith(
            bottom: math.max(0, media.viewPadding.bottom - space),
          ),
        ),
        child: child,
      ),
    );
  }
}

class NavBarCoverScope extends InheritedWidget {
  const NavBarCoverScope({
    super.key,
    required this.cover,
    required super.child,
  });

  final NavBarCover cover;

  static NavBarCover? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<NavBarCoverScope>()?.cover;

  @override
  bool updateShouldNotify(NavBarCoverScope oldWidget) =>
      oldWidget.cover != cover;
}

mixin NavBarCovering<T extends StatefulWidget> on State<T> {
  NavBarCover? _cover;
  ModalRoute<Object?>? _route;

  void _onMove() {
    final ModalRoute<Object?>? route = _route;
    if (route == null) return;
    final double shown = route.animation?.value ?? 1;
    final double covered = route.secondaryAnimation?.value ?? 0;
    _cover?.cover(this, shown * (1 - covered));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cover ??= NavBarCoverScope.maybeOf(context);
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
  void dispose() {
    _route?.animation?.removeListener(_onMove);
    _route?.secondaryAnimation?.removeListener(_onMove);
    _cover?.cover(this, 0);
    super.dispose();
  }
}

class NavBarCovered extends StatefulWidget {
  const NavBarCovered({super.key, required this.child});

  final Widget child;

  @override
  State<NavBarCovered> createState() => _NavBarCoveredState();
}

class _NavBarCoveredState extends State<NavBarCovered> with NavBarCovering {
  @override
  Widget build(BuildContext context) =>
      NavBarCoveredPadding(child: widget.child);
}

class NavBarPopupObserver extends NavigatorObserver {
  NavBarPopupObserver(this.cover);

  final NavBarCover cover;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is! PopupRoute) return;
    if ((route.barrierColor?.a ?? 0) == 0) return;
    final Animation<double>? animation = route.animation;
    if (animation == null) return;
    void update() => cover.cover(route, animation.value);
    void settle(AnimationStatus status) {
      if (!status.isDismissed) return;
      animation.removeListener(update);
      animation.removeStatusListener(settle);
      cover.cover(route, 0);
    }

    animation
      ..addListener(update)
      ..addStatusListener(settle);
    update();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      cover.cover(route, 0);

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) cover.cover(oldRoute, 0);
  }
}
