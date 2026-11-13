import 'dart:ui';

import 'package:flutter/material.dart';

enum HexagonState { tracing, armed, loading, failed, end }

class HexagonalLoadingIndicator extends StatefulWidget {
  const HexagonalLoadingIndicator({
    super.key,
    this.state = HexagonState.loading,
    this.progress = 1,
    this.size = 40,
  });

  final HexagonState state;
  final double progress;
  final double size;

  @override
  State<HexagonalLoadingIndicator> createState() =>
      _HexagonalLoadingIndicatorState();
}

class _HexagonalLoadingIndicatorState extends State<HexagonalLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController travel = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  void _sync() {
    if (widget.state == HexagonState.loading) {
      if (!travel.isAnimating) travel.repeat();
    } else {
      travel.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(covariant HexagonalLoadingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  @override
  void dispose() {
    travel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AnimatedBuilder(
      animation: travel,
      builder: (context, child) => CustomPaint(
        size: Size.square(widget.size),
        painter: HexagonalLoadingPainter(
          state: widget.state,
          progress: widget.progress,
          phase: travel.value,
          accent: theme.colorScheme.primary,
          ink: theme.colorScheme.onSurface,
          error: theme.colorScheme.error,
        ),
      ),
    );
  }
}

class HexagonalLoadingPainter extends CustomPainter {
  const HexagonalLoadingPainter({
    required this.state,
    required this.progress,
    required this.phase,
    required this.accent,
    required this.ink,
    required this.error,
  });

  final HexagonState state;
  final double progress;
  final double phase;
  final Color accent;
  final Color ink;
  final Color error;

  static Path hexagon(Size size) {
    final double s = size.width / 48;
    return Path()
      ..moveTo(24 * s, 3 * s)
      ..lineTo(42 * s, 13.5 * s)
      ..lineTo(42 * s, 34.5 * s)
      ..lineTo(24 * s, 45 * s)
      ..lineTo(6 * s, 34.5 * s)
      ..lineTo(6 * s, 13.5 * s)
      ..close();
  }

  Paint _stroke(Color color, double width) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeJoin = StrokeJoin.round
    ..strokeCap = StrokeCap.round
    ..color = color;

  @override
  void paint(Canvas canvas, Size size) {
    final Path shape = hexagon(size);
    final double width = 3 * size.width / 48;
    final PathMetric edge = shape.computeMetrics().first;
    switch (state) {
      case HexagonState.tracing:
        canvas.drawPath(shape, _stroke(ink.withValues(alpha: 0.15), width));
        final double traced = edge.length * progress;
        if (traced > width) {
          canvas.drawPath(
            edge.extractPath(width / 2, traced - width / 2),
            _stroke(
              ink.withValues(
                alpha: 0.75 * ((traced - width) / width).clamp(0, 1),
              ),
              width,
            ),
          );
        }
      case HexagonState.armed:
        canvas.drawPath(shape, Paint()..color = accent.withValues(alpha: 0.9));
        canvas.drawPath(shape, _stroke(accent, width));
      case HexagonState.loading:
        canvas.drawPath(shape, Paint()..color = accent.withValues(alpha: 0.14));
        canvas.drawPath(shape, _stroke(accent.withValues(alpha: 0.35), width));
        final double length = edge.length * 32 / 126;
        final double start = edge.length * phase;
        final double end = start + length;
        final Paint segment = _stroke(accent, width);
        canvas.drawPath(edge.extractPath(start, end), segment);
        if (end > edge.length) {
          canvas.drawPath(edge.extractPath(0, end - edge.length), segment);
        }
      case HexagonState.failed:
        final double unit = edge.length / 126;
        final double s = size.width / 48;
        final Paint broken = _stroke(error.withValues(alpha: 0.9), width);
        canvas.drawPath(edge.extractPath(0, 70 * unit), broken);
        canvas.drawPath(edge.extractPath(84 * unit, 126 * unit), broken);
        canvas.drawPath(
          Path()
            ..moveTo(17.6 * s, 41.3 * s)
            ..lineTo(19.4 * s, 36.2 * s)
            ..lineTo(16.2 * s, 33.4 * s)
            ..lineTo(20.6 * s, 28.2 * s),
          broken..strokeWidth = 2.5 * s,
        );
      case HexagonState.end:
        canvas.drawPath(shape, Paint()..color = ink.withValues(alpha: 0.14));
        canvas.drawPath(shape, _stroke(ink.withValues(alpha: 0.2), width));
    }
  }

  @override
  bool shouldRepaint(covariant HexagonalLoadingPainter oldDelegate) =>
      oldDelegate.state != state ||
      oldDelegate.progress != progress ||
      oldDelegate.phase != phase ||
      oldDelegate.accent != accent ||
      oldDelegate.ink != ink ||
      oldDelegate.error != error;
}
