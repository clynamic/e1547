import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class HeightLimit extends SingleChildRenderObjectWidget {
  const HeightLimit({
    super.key,
    required this.maxHeight,
    required this.onOverflow,
    this.tolerance = 0,
    super.child,
  });

  final double maxHeight;
  final double tolerance;
  final ValueChanged<bool> onOverflow;

  @override
  RenderObject createRenderObject(BuildContext context) => RenderHeightLimit(
    maxHeight: maxHeight,
    tolerance: tolerance,
    onOverflow: onOverflow,
  );

  @override
  void updateRenderObject(
    BuildContext context,
    RenderHeightLimit renderObject,
  ) => renderObject
    ..maxHeight = maxHeight
    ..tolerance = tolerance
    ..onOverflow = onOverflow;
}

class RenderHeightLimit extends RenderProxyBox {
  RenderHeightLimit({
    required double maxHeight,
    required this.onOverflow,
    double tolerance = 0,
  }) : _maxHeight = maxHeight,
       _tolerance = tolerance;

  double _maxHeight;
  double get maxHeight => _maxHeight;
  set maxHeight(double value) {
    if (value == _maxHeight) return;
    _maxHeight = value;
    markNeedsLayout();
  }

  double _tolerance;
  double get tolerance => _tolerance;
  set tolerance(double value) {
    if (value == _tolerance) return;
    _tolerance = value;
    markNeedsLayout();
  }

  ValueChanged<bool> onOverflow;
  bool? _overflows;

  bool get overflows => _overflows ?? false;

  @override
  void performLayout() {
    final RenderBox? child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    child.layout(
      constraints.copyWith(minHeight: 0, maxHeight: double.infinity),
      parentUsesSize: true,
    );
    final double height = child.size.height <= maxHeight + tolerance
        ? child.size.height
        : maxHeight;
    size = constraints.constrain(Size(child.size.width, height));
    final bool overflows = child.size.height > size.height;
    if (overflows != _overflows) {
      _overflows = overflows;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (attached) onOverflow(overflows);
      });
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!overflows) return super.paint(context, offset);
    layer = context.pushClipRect(
      needsCompositing,
      offset,
      Offset.zero & size,
      super.paint,
      oldLayer: layer as ClipRectLayer?,
    );
  }
}
