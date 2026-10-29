import 'package:e1547/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double loadMoreSize = 36;

enum LoadMoreState { loading, failed, end }

class LoadMoreFooter extends StatelessWidget {
  const LoadMoreFooter({
    super.key,
    required this.state,
    this.label,
    this.onRetry,
    this.note,
  });

  final LoadMoreState state;
  final String? label;
  final VoidCallback? onRetry;
  final Widget? note;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color dim = theme.colorScheme.onSurface.withValues(alpha: 0.5);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          switch (state) {
            LoadMoreState.loading => const HexagonRefreshIndicator(
              mode: RefreshIndicatorMode.refresh,
              progress: 1,
              size: loadMoreSize,
            ),
            _ => CustomPaint(
              size: const Size.square(loadMoreSize),
              painter: LoadMorePainter(
                state: state,
                ink: theme.colorScheme.onSurface,
                error: Colors.red.shade300,
              ),
            ),
          },
          if (label != null || onRetry != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                if (label case final label?)
                  Text(label, style: TextStyle(fontSize: 14, color: dim)),
                if (onRetry case final onRetry?)
                  RetryButton(onPressed: onRetry),
              ],
            ),
          ?note,
        ],
      ),
    );
  }
}

class LoadMorePainter extends CustomPainter {
  const LoadMorePainter({
    required this.state,
    required this.ink,
    required this.error,
  });

  final LoadMoreState state;
  final Color ink;
  final Color error;

  @override
  void paint(Canvas canvas, Size size) {
    final Path shape = HexagonRefreshPainter.hexagon(size);
    final double width = 3 * size.width / 48;
    Paint stroke(Color color) => Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeJoin = StrokeJoin.round
      ..color = color;
    switch (state) {
      case LoadMoreState.loading:
        return;
      case LoadMoreState.failed:
        final metric = shape.computeMetrics().first;
        final double unit = metric.length / 126;
        final Paint paint = stroke(error.withValues(alpha: 0.8));
        canvas.drawPath(metric.extractPath(0, 70 * unit), paint);
        canvas.drawPath(metric.extractPath(84 * unit, 126 * unit), paint);
      case LoadMoreState.end:
        canvas.drawPath(shape, Paint()..color = ink.withValues(alpha: 0.14));
        canvas.drawPath(shape, stroke(ink.withValues(alpha: 0.2)));
    }
  }

  @override
  bool shouldRepaint(covariant LoadMorePainter oldDelegate) =>
      oldDelegate.state != state ||
      oldDelegate.ink != ink ||
      oldDelegate.error != error;
}

class RetryButton extends StatelessWidget {
  const RetryButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 36),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        foregroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.9),
        side: BorderSide(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: const Text('Retry'),
    );
  }
}
