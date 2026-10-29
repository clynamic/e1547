import 'dart:math';

import 'package:flutter/material.dart';

class DragToOpen extends StatefulWidget {
  const DragToOpen({
    super.key,
    required this.open,
    required this.child,
    this.extent = 400,
  });

  final Future<void> Function(AnimationController transition) open;
  final Widget child;
  final double extent;

  @override
  State<DragToOpen> createState() => _DragToOpenState();
}

class _DragToOpenState extends State<DragToOpen> with TickerProviderStateMixin {
  double _progress = 0;

  void _update(DragUpdateDetails details) => setState(
    () => _progress = (_progress - (details.primaryDelta ?? 0) / widget.extent)
        .clamp(0, 1),
  );

  void _end(DragEndDetails details) {
    final double progress = _progress;
    setState(() => _progress = 0);
    final double velocity = details.primaryVelocity ?? 0;
    if (velocity >= -300 && progress <= 0.3) return;
    final AnimationController transition = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    widget.open(transition).whenComplete(() {
      if (transition.isDismissed) {
        transition.dispose();
        return;
      }
      void release(AnimationStatus status) {
        if (!status.isDismissed) return;
        transition.removeStatusListener(release);
        transition.dispose();
      }

      transition.addStatusListener(release);
    });
    transition
      ..value = progress
      ..forward();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onVerticalDragUpdate: _update,
    onVerticalDragEnd: _end,
    onVerticalDragCancel: () => setState(() => _progress = 0),
    child: AnimatedSlide(
      offset: Offset(0, -min(_progress, 0.1)),
      duration: _progress == 0
          ? const Duration(milliseconds: 150)
          : Duration.zero,
      child: widget.child,
    ),
  );
}
