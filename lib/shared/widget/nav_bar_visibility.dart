import 'dart:math';

import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

const double navBarRevealDistance = 96;
const Duration navBarSettleDuration = Duration(milliseconds: 250);

class NavBarVisibility extends ChangeNotifier {
  NavBarVisibility({required this.height});

  final double height;

  double _hidden = 0;
  double _climb = 0;
  bool _settling = false;

  double get hidden => _hidden / height;

  bool get settling => _settling;

  void show() {
    _climb = 0;
    _move(0, settle: true);
  }

  void _move(double value, {required bool settle}) {
    value = value.clamp(0, height);
    if (value == _hidden && settle == _settling) return;
    _hidden = value;
    _settling = settle;
    notifyListeners();
  }

  void _settle() => _move(_hidden < height / 2 ? 0 : height, settle: true);

  bool absorb(ScrollNotification notification) {
    if (notification.depth != 0) return false;
    final ScrollMetrics metrics = notification.metrics;
    if (metrics.axis != Axis.vertical) return false;
    if (!metrics.hasContentDimensions) return false;
    if (metrics.maxScrollExtent <= metrics.minScrollExtent ||
        metrics.pixels <= metrics.minScrollExtent) {
      if (notification is ScrollUpdateNotification ||
          notification is OverscrollNotification ||
          notification is ScrollEndNotification) {
        show();
      }
      return false;
    }
    if (notification is ScrollEndNotification) {
      _climb = 0;
      _settle();
      return false;
    }
    if (notification is! ScrollUpdateNotification) return false;
    final double delta = notification.scrollDelta ?? 0;
    if (delta > 0) {
      _climb = 0;
      _move(_hidden + delta, settle: false);
    } else if (delta < 0 && _hidden > 0) {
      _climb -= delta;
      final double excess = _climb - navBarRevealDistance;
      if (excess > 0) _move(_hidden - min(excess, -delta), settle: false);
    }
    return false;
  }
}

class NavBarScrollListener extends StatelessWidget {
  const NavBarScrollListener({
    super.key,
    required this.controller,
    required this.child,
    this.cover,
  });

  final NavBarVisibility controller;
  final NavBarCover? cover;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollNotification>(
        onNotification: (notification) =>
            !(cover?.covered ?? false) && controller.absorb(notification),
        child: child,
      );
}

class NavBarSlide extends StatelessWidget {
  const NavBarSlide({super.key, required this.controller, required this.child});

  final NavBarVisibility controller;
  final Widget child;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, child) => AnimatedSlide(
      offset: Offset(0, controller.hidden),
      duration: controller.settling ? navBarSettleDuration : Duration.zero,
      curve: Curves.easeOutCubic,
      child: IgnorePointer(ignoring: controller.hidden >= 1, child: child),
    ),
    child: child,
  );
}
