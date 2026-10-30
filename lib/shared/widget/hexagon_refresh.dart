import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:e1547/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const ScrollPhysics refreshPhysics = AlwaysScrollableScrollPhysics(
  parent: BouncingScrollPhysics(),
);

typedef SliverTop = List<Widget> Function(Future<void> Function()? onRefresh);

typedef RefreshNoteBuilder =
    Widget Function(BuildContext context, VoidCallback refresh);

class RefreshNote extends ValueNotifier<RefreshNoteBuilder?> {
  RefreshNote() : super(null);
}

const Duration refreshNoteDuration = Duration(milliseconds: 1500);

const double hexagonRefreshTrigger = 64;
const double hexagonRefreshExtent = 64;
const double hexagonRefreshSize = 40;

class SliverHexagonRefresh extends StatefulWidget {
  const SliverHexagonRefresh({
    super.key,
    required this.onRefresh,
    this.header,
    this.headerExtent = 0,
  });

  final Future<void> Function() onRefresh;
  final Widget? header;
  final double? headerExtent;

  @override
  State<SliverHexagonRefresh> createState() => _SliverHexagonRefreshState();
}

class _SliverHexagonRefreshState extends State<SliverHexagonRefresh>
    with SingleTickerProviderStateMixin {
  late final AnimationController hold = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );
  bool refreshing = false;
  bool armed = false;
  double? measured;

  void _onHeaderSize(Size size) {
    if (!mounted || size.height == measured) return;
    setState(() => measured = size.height);
  }

  int pointers = 0;
  RefreshNoteBuilder? note;
  Timer? noteTimer;
  ScrollPosition? position;

  @override
  void initState() {
    super.initState();
    GestureBinding.instance.pointerRouter.addGlobalRoute(_onPointer);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ScrollPosition? next = Scrollable.maybeOf(context)?.position;
    if (next == position) return;
    position?.removeListener(_onScroll);
    position = next?..addListener(_onScroll);
  }

  @override
  void dispose() {
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_onPointer);
    position?.removeListener(_onScroll);
    noteTimer?.cancel();
    hold.dispose();
    super.dispose();
  }

  void _onPointer(PointerEvent event) {
    if (event is PointerDownEvent) {
      pointers++;
      if (note != null) _closeNote();
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      pointers = max(0, pointers - 1);
      if (pointers == 0 && armed) {
        armed = false;
        WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
      }
    }
  }

  void _closeNote() {
    noteTimer?.cancel();
    if (!mounted || note == null) return;
    setState(() => note = null);
    hold.reverse();
  }

  void _onScroll() {
    final ScrollPosition? position = this.position;
    if (position == null || refreshing || pointers == 0) return;
    armed = position.minScrollExtent - position.pixels >= hexagonRefreshTrigger;
  }

  Future<void> _refresh() async {
    if (refreshing || !mounted) return;
    final RefreshNote? notes = context.read<RefreshNote?>();
    notes?.value = null;
    noteTimer?.cancel();
    setState(() {
      refreshing = true;
      note = null;
    });
    hold.forward();
    try {
      await widget.onRefresh();
    } finally {
      if (mounted) {
        final RefreshNoteBuilder? next = notes?.value;
        setState(() {
          refreshing = false;
          note = next;
        });
        if (next == null) {
          hold.reverse();
        } else {
          noteTimer = Timer(refreshNoteDuration, _closeNote);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: hold,
    builder: (context, child) => SliverPersistentHeader(
      delegate: _HexagonHeaderDelegate(
        extent: widget.headerExtent ?? measured ?? 0,
        held: Curves.easeOutCubic.transform(hold.value) * hexagonRefreshExtent,
        header: switch (widget.header) {
          final Widget header when widget.headerExtent == null => SizeReporter(
            onSize: _onHeaderSize,
            child: header,
          ),
          final header => header,
        },
        refreshing: refreshing,
        note: switch (note) {
          final RefreshNoteBuilder note => note(context, _refresh),
          null => null,
        },
      ),
    ),
  );
}

class _HexagonHeaderDelegate extends SliverPersistentHeaderDelegate {
  _HexagonHeaderDelegate({
    required this.extent,
    required this.held,
    required this.header,
    required this.refreshing,
    required this.note,
  });

  final double extent;
  final double held;
  final Widget? header;
  final bool refreshing;
  final Widget? note;

  @override
  double get minExtent => extent + held;

  @override
  double get maxExtent => extent + held;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration();

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => LayoutBuilder(
    builder: (context, constraints) {
      final double pull = (constraints.maxHeight - extent - held).clamp(
        0,
        double.infinity,
      );
      final double space = pull + held;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          if (note != null && space > 0)
            Positioned(
              left: 0,
              right: 0,
              top: extent,
              height: space,
              child: ClipRect(child: Center(child: note)),
            )
          else if (space > 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: max(0, (space - hexagonRefreshSize) / 2),
              child: Center(
                child: HexagonRefreshIndicator(
                  mode: refreshing
                      ? RefreshIndicatorMode.refresh
                      : pull >= hexagonRefreshTrigger
                      ? RefreshIndicatorMode.armed
                      : RefreshIndicatorMode.drag,
                  progress: (pull / hexagonRefreshTrigger).clamp(0, 1),
                ),
              ),
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: extent,
            child: OverflowBox(
              alignment: Alignment.topCenter,
              maxHeight: double.infinity,
              child: header ?? const SizedBox.shrink(),
            ),
          ),
        ],
      );
    },
  );

  @override
  bool shouldRebuild(covariant _HexagonHeaderDelegate oldDelegate) => true;
}

class HexagonRefreshIndicator extends StatefulWidget {
  const HexagonRefreshIndicator({
    super.key,
    required this.mode,
    required this.progress,
    this.size = hexagonRefreshSize,
  });

  final RefreshIndicatorMode mode;
  final double progress;
  final double size;

  @override
  State<HexagonRefreshIndicator> createState() =>
      _HexagonRefreshIndicatorState();
}

class _HexagonRefreshIndicatorState extends State<HexagonRefreshIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController travel = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  void _sync() {
    if (widget.mode == RefreshIndicatorMode.refresh) {
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
  void didUpdateWidget(covariant HexagonRefreshIndicator oldWidget) {
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
    if (widget.mode == RefreshIndicatorMode.inactive) {
      return const SizedBox.shrink();
    }
    return AnimatedBuilder(
      animation: travel,
      builder: (context, child) => CustomPaint(
        size: Size.square(widget.size),
        painter: HexagonRefreshPainter(
          mode: widget.mode,
          progress: widget.progress,
          phase: travel.value,
          accent: theme.colorScheme.primary,
          ink: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}

class HexagonRefreshPainter extends CustomPainter {
  const HexagonRefreshPainter({
    required this.mode,
    required this.progress,
    required this.phase,
    required this.accent,
    required this.ink,
  });

  final RefreshIndicatorMode mode;
  final double progress;
  final double phase;
  final Color accent;
  final Color ink;

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
    switch (mode) {
      case RefreshIndicatorMode.inactive:
        return;
      case RefreshIndicatorMode.drag:
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
      case RefreshIndicatorMode.armed:
      case RefreshIndicatorMode.done:
        canvas.drawPath(shape, Paint()..color = accent.withValues(alpha: 0.9));
        canvas.drawPath(shape, _stroke(accent, width));
      case RefreshIndicatorMode.refresh:
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
    }
  }

  @override
  bool shouldRepaint(covariant HexagonRefreshPainter oldDelegate) =>
      oldDelegate.mode != mode ||
      oldDelegate.progress != progress ||
      oldDelegate.phase != phase ||
      oldDelegate.accent != accent ||
      oldDelegate.ink != ink;
}
