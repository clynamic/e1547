import 'dart:math';

import 'package:flutter/material.dart';

const double _dismissTravel = 1000;
const double _dismissFadeRate = 2;
const Duration _dismissDuration = Duration(milliseconds: 300);

class DismissRoute<T> extends PageRoute<T> {
  DismissRoute({required this.builder, super.settings});

  final WidgetBuilder builder;

  late final AnimationController drag;
  double direction = 1;
  bool settling = false;
  bool blocked = false;
  bool fromEdge = false;
  double released = 0;

  AnimationController get driver => controller!;

  double momentum(double velocity) => direction * velocity / _dismissTravel;

  bool get dismissible => isActive && !isFirst;

  bool get dragging => drag.value > 0;

  double get dragOffset => direction * drag.value * _dismissTravel;

  double get dragProgress => (dragOffset.abs() / 240).clamp(0, 1);

  @override
  void install() {
    super.install();
    drag = AnimationController(vsync: navigator!, duration: _dismissDuration)
      ..addStatusListener(_onDrag)
      ..addListener(_onDragValue);
  }

  void _onDrag(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) settling = false;
  }

  bool _revealing = false;

  void _onDragValue() {
    if (dragging == _revealing || overlayEntries.isEmpty) return;
    _revealing = dragging;
    overlayEntries.first.opaque = !dragging && driver.isCompleted;
  }

  @override
  bool didPop(T? result) {
    final bool popped = super.didPop(result);
    if (dragging) {
      drag.fling(
        velocity: max(0.001, momentum(released)),
        springDescription: SpringDescription.withDampingRatio(
          mass: 1,
          stiffness: 150,
        ),
      );
    }
    return popped;
  }

  @override
  Color get barrierColor => Colors.transparent;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => _dismissDuration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) => builder(context);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ListenableBuilder(
      listenable: Listenable.merge([animation, drag]),
      builder: (context, child) => Stack(
        fit: StackFit.expand,
        children: [
          IgnorePointer(
            child: ColoredBox(
              color: Colors.black54.withValues(
                alpha: Colors.black54.a * _scrim(animation),
              ),
            ),
          ),
          if (dragging)
            child!
          else
            Theme.of(context).pageTransitionsTheme.buildTransitions<T>(
              this,
              context,
              animation,
              kAlwaysDismissedAnimation,
              child!,
            ),
        ],
      ),
      child: child,
    );
  }

  double _scrim(Animation<double> animation) =>
      dragging ? 1 - dragProgress : animation.value;

  @override
  void dispose() {
    drag.dispose();
    super.dispose();
  }
}

class DismissController implements Listenable {
  const DismissController(this.route);

  final DismissRoute<dynamic> route;

  static DismissController? maybeOf(BuildContext context) {
    final ModalRoute<dynamic>? route = ModalRoute.of(context);
    if (route is! DismissRoute<dynamic>) return null;
    return DismissController(route);
  }

  double get offset => route.dragOffset;

  double get progress => route.dragProgress;

  double get scale => 1 - 0.28 * progress;

  bool get isDragging => route.dragging;

  bool get fromEdge => route.fromEdge;

  set fromEdge(bool value) => route.fromEdge = value;

  double opacity(double rate) => (1 - progress * rate).clamp(0, 1);

  bool exceeds(double velocity) {
    final double reached = offset;
    if (reached.abs() > 120) return true;
    if (reached == 0) return false;
    return velocity.sign == reached.sign && velocity.abs() > 700;
  }

  void settle([double velocity = 0]) {
    if (!route.dismissible || !route.dragging) return;
    route.settling = true;
    route.drag.fling(velocity: min(-0.001, route.momentum(velocity)));
  }

  void push(double delta) {
    if (!route.dismissible || route.blocked) return;
    if (!route.dragging && !route.driver.isCompleted) return;
    route.settling = false;
    route.released = 0;
    if (!route.dragging) route.direction = delta.isNegative ? -1 : 1;
    final double next =
        route.drag.value + delta * route.direction / _dismissTravel;
    route.drag.value = next.clamp(0, 1);
  }

  bool release(double velocity) {
    if (!route.dismissible || !route.dragging || route.settling) return false;
    if (exceeds(velocity)) {
      route.released = velocity;
      return true;
    }
    settle(velocity);
    return false;
  }

  @override
  void addListener(VoidCallback listener) => route.drag.addListener(listener);

  @override
  void removeListener(VoidCallback listener) =>
      route.drag.removeListener(listener);
}

class DismissFade extends StatelessWidget {
  const DismissFade({
    super.key,
    required this.child,
    this.rate = _dismissFadeRate,
  });

  final Widget child;
  final double rate;

  @override
  Widget build(BuildContext context) {
    final DismissController? controller = DismissController.maybeOf(context);
    if (controller == null) return child;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) => IgnorePointer(
        ignoring: controller.isDragging,
        child: Opacity(opacity: controller.opacity(rate), child: child),
      ),
      child: child,
    );
  }
}

class DismissSliverFade extends StatelessWidget {
  const DismissSliverFade({
    super.key,
    required this.sliver,
    this.rate = _dismissFadeRate,
  });

  final Widget sliver;
  final double rate;

  @override
  Widget build(BuildContext context) {
    final DismissController? controller = DismissController.maybeOf(context);
    if (controller == null) return sliver;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) => SliverIgnorePointer(
        ignoring: controller.isDragging,
        sliver: SliverOpacity(opacity: controller.opacity(rate), sliver: child),
      ),
      child: sliver,
    );
  }
}

class DismissTransform extends StatelessWidget {
  const DismissTransform({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final DismissController? controller = DismissController.maybeOf(context);
    if (controller == null) return child;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, controller.offset),
        child: Transform.scale(scale: controller.scale, child: child),
      ),
      child: child,
    );
  }
}

class DismissPointers extends StatelessWidget {
  const DismissPointers({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final DismissController? controller = DismissController.maybeOf(context);
    if (controller == null) return child;
    return Listener(
      onPointerDown: (event) {
        final Rect free = MediaQuery.systemGestureInsetsOf(
          context,
        ).deflateRect(Offset.zero & MediaQuery.sizeOf(context));
        controller.route.blocked = !free.contains(event.position);
      },
      onPointerCancel: (event) => controller.settle(),
      child: child,
    );
  }
}

class DismissScrollPhysics extends ScrollPhysics {
  const DismissScrollPhysics({required this.controller, super.parent});

  final DismissController controller;

  @override
  DismissScrollPhysics applyTo(ScrollPhysics? ancestor) => DismissScrollPhysics(
    controller: controller,
    parent: buildParent(ancestor),
  );

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    if (controller.isDragging) return null;
    return super.createBallisticSimulation(position, velocity);
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (position.axis != Axis.vertical) {
      return super.applyPhysicsToUserOffset(position, offset);
    }
    if (offset > 0 &&
        position.pixels <= position.minScrollExtent &&
        controller.fromEdge) {
      controller.push(offset);
      return 0;
    }
    if (offset < 0 && controller.offset > 0) {
      final double taken = min(controller.offset, -offset);
      controller.push(-taken);
      final double rest = offset + taken;
      if (rest == 0) return 0;
      return super.applyPhysicsToUserOffset(position, rest);
    }
    return super.applyPhysicsToUserOffset(position, offset);
  }
}

class ScrollToDismiss extends StatefulWidget {
  const ScrollToDismiss({super.key, required this.child});

  final Widget child;

  @override
  State<ScrollToDismiss> createState() => _ScrollToDismissState();
}

class _ScrollToDismissState extends State<ScrollToDismiss> {
  DismissController? _controller;
  ScrollBehavior? _behavior;
  bool _dragging = false;

  void _release(double velocity) {
    _dragging = false;
    if (_controller!.release(velocity)) Navigator.of(context).maybePop();
  }

  bool _onNotification(ScrollNotification notification) {
    if (notification.depth != 0) return false;
    if (notification.metrics.axis != Axis.vertical) return false;
    switch (notification) {
      case ScrollUpdateNotification(:final DragUpdateDetails? dragDetails):
        if (dragDetails != null) {
          _dragging = true;
        } else if (_dragging) {
          _release(0);
        }
      case ScrollEndNotification(:final DragEndDetails? dragDetails):
        _release(dragDetails?.velocity.pixelsPerSecond.dy ?? 0);
      case ScrollStartNotification(:final DragStartDetails? dragDetails):
        if (!_dragging) _controller!.settle();
        _dragging = dragDetails != null;
        if (_dragging) {
          _controller!.fromEdge =
              notification.metrics.pixels <=
              notification.metrics.minScrollExtent;
        }
      default:
        break;
    }
    return false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final DismissController? controller = DismissController.maybeOf(context);
    _controller = controller;
    if (controller == null) {
      _behavior = null;
      return;
    }
    final ScrollBehavior behavior = ScrollConfiguration.of(context);
    _behavior = behavior.copyWith(
      physics: DismissScrollPhysics(
        controller: controller,
      ).applyTo(behavior.getScrollPhysics(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ScrollBehavior? behavior = _behavior;
    if (behavior == null) return widget.child;
    return DismissPointers(
      child: NotificationListener<ScrollNotification>(
        onNotification: _onNotification,
        child: ScrollConfiguration(
          behavior: behavior,
          child: DismissTransform(child: widget.child),
        ),
      ),
    );
  }
}

class DragToDismiss extends StatelessWidget {
  const DragToDismiss({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final DismissController? controller = DismissController.maybeOf(context);
    if (controller == null) return child;
    return DismissPointers(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragUpdate: (details) => controller.push(details.delta.dy),
        onVerticalDragEnd: (details) {
          if (controller.release(details.velocity.pixelsPerSecond.dy)) {
            Navigator.of(context).maybePop();
          }
        },
        onVerticalDragCancel: controller.settle,
        child: DismissTransform(child: child),
      ),
    );
  }
}
