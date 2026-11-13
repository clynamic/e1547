import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

Future<T?> showAppSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  Color? color,
  SheetOffset initialOffset = const SheetOffset(1),
  SheetSnapGrid snapGrid = const SheetSnapGrid.single(snap: SheetOffset(1)),
}) => AppSheet<T>(
  builder: builder,
  color: color,
  initialOffset: initialOffset,
  snapGrid: snapGrid,
).show(context);

class AppSheet<T> {
  const AppSheet({
    required this.builder,
    this.color,
    this.initialOffset = const SheetOffset(1),
    this.snapGrid = const SheetSnapGrid.single(snap: SheetOffset(1)),
  });

  final WidgetBuilder builder;
  final Color? color;
  final SheetOffset initialOffset;
  final SheetSnapGrid snapGrid;

  EdgeInsets padding(MediaQueryData media) {
    final double side = max(0, (media.size.width - 600) / 2);
    return EdgeInsets.only(
      left: side,
      top: media.viewPadding.top,
      right: side,
      bottom: media.viewInsets.bottom,
    );
  }

  Widget decorate(BuildContext context, Widget child) => Material(
    color: color ?? Theme.of(context).canvasColor,
    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
    clipBehavior: Clip.antiAlias,
    child: child,
  );

  ModalSheetTransitionRoute<T> route(
    BuildContext context, {
    AnimationController? transition,
  }) => ModalSheetTransitionRoute<T>(
    transition: transition,
    swipeDismissSensitivity: SwipeDismissSensitivity(
      minFlingVelocityRatio: 700 / MediaQuery.sizeOf(context).height,
    ),
    viewportBuilder: (context, child) =>
        SheetViewport(padding: padding(MediaQuery.of(context)), child: child),
    builder: (context) => SheetKeyboardDismissible(
      dismissBehavior: const SheetKeyboardDismissBehavior.onDragDown(),
      child: SheetCloseRule(
        child: Sheet(
          initialOffset: initialOffset,
          snapGrid: snapGrid,
          scrollConfiguration: const SheetScrollConfiguration(
            scrollSyncMode: SheetScrollHandlingBehavior.onlyFromTop,
          ),
          decoration: SheetDecorationBuilder(
            size: SheetSize.fit,
            builder: decorate,
          ),
          child: builder(context),
        ),
      ),
    ),
  );

  Future<T?> show(BuildContext context, {AnimationController? transition}) =>
      Navigator.of(
        context,
        rootNavigator: true,
      ).push(route(context, transition: transition));
}

class SheetCloseRule extends StatelessWidget {
  const SheetCloseRule({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      NotificationListener<SheetDragEndNotification>(
        onNotification: (notification) {
          final ModalRoute<Object?>? route = ModalRoute.of(context);
          if (route == null || !route.isCurrent) return false;
          final SheetMetrics metrics = notification.metrics;
          final double dragged =
              metrics.viewportSize.height * (1 - route.animation!.value);
          final double shown = metrics.offset - metrics.viewportPadding.bottom;
          if (dragged > shown * 0.5) {
            Navigator.of(context).maybePop();
          }
          return false;
        },
        child: child,
      );
}

class ModalSheetTransitionRoute<T> extends ModalSheetRoute<T> {
  ModalSheetTransitionRoute({
    required super.builder,
    super.viewportBuilder,
    super.swipeDismissSensitivity,
    this.transition,
  }) : super(swipeDismissible: true);

  final AnimationController? transition;

  @override
  AnimationController createAnimationController() {
    final AnimationController? transition = this.transition;
    if (transition == null) return super.createAnimationController();
    willDisposeAnimationController = false;
    return transition;
  }
}
