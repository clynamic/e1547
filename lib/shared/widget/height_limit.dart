import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class HeightLimit extends SingleChildRenderObjectWidget {
  const HeightLimit({
    super.key,
    required this.maxHeight,
    required this.onOverflow,
    super.child,
  });

  final double maxHeight;
  final ValueChanged<bool> onOverflow;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderHeightLimit(maxHeight: maxHeight, onOverflow: onOverflow);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderHeightLimit renderObject,
  ) => renderObject
    ..maxHeight = maxHeight
    ..onOverflow = onOverflow;
}

class RenderHeightLimit extends RenderProxyBox {
  RenderHeightLimit({required double maxHeight, required this.onOverflow})
    : _maxHeight = maxHeight;

  double _maxHeight;
  double get maxHeight => _maxHeight;
  set maxHeight(double value) {
    if (value == _maxHeight) return;
    _maxHeight = value;
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
    size = constraints.constrain(
      Size(child.size.width, math.min(child.size.height, maxHeight)),
    );
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
