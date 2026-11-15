import 'dart:math';

import 'package:e1547/shared/shared.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

const double _zoomMin = 1;
const double _zoomReach = 6;
const double _zoomFriction = 0.0000135;
const double _edgeSlack = 0.5;

class ZoomController extends ChangeNotifier {
  final TransformationController transformation = TransformationController();

  double _scale = _zoomMin;

  double get scale => _scale;

  bool get isZoomed => _scale > _zoomMin + 0.08;

  void _read() {
    final double next = transformation.value.getMaxScaleOnAxis();
    if ((next - _scale).abs() < 0.001) return;
    _scale = next;
    notifyListeners();
  }

  @override
  void dispose() {
    transformation.dispose();
    super.dispose();
  }
}

class Zoomable extends StatefulWidget {
  const Zoomable({
    super.key,
    required this.child,
    required this.controller,
    required this.content,
    this.onTap,
    this.onSpare,
    this.onSpareEnd,
    this.onSpareCancel,
  });

  final Widget child;
  final ZoomController controller;
  final Size content;
  final VoidCallback? onTap;
  final void Function(Offset spare)? onSpare;
  final void Function(Velocity velocity)? onSpareEnd;
  final VoidCallback? onSpareCancel;

  @override
  State<Zoomable> createState() => _ZoomableState();
}

enum _ZoomGesture { pan, scale }

class _ZoomableState extends State<Zoomable> with TickerProviderStateMixin {
  late final AnimationController animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  late final AnimationController coast = AnimationController(vsync: this);
  Animation<Matrix4>? _flight;
  VoidCallback? _coasting;
  TapDownDetails? _lastTap;

  TransformationController get transformation =>
      widget.controller.transformation;

  @override
  void initState() {
    super.initState();
    transformation.addListener(_clamp);
    transformation.addListener(widget.controller._read);
    animation.addListener(_onFlight);
    coast.addListener(_onCoast);
  }

  @override
  void dispose() {
    transformation.removeListener(_clamp);
    transformation.removeListener(widget.controller._read);
    animation
      ..removeListener(_onFlight)
      ..dispose();
    coast
      ..removeListener(_onCoast)
      ..dispose();
    super.dispose();
  }

  void _onFlight() {
    if (_flight case final Animation<Matrix4> value) {
      transformation.value = value.value;
    }
  }

  void _onCoast() {
    if (coast.isAnimating) _coasting?.call();
  }

  void _settle() {
    if (widget.controller.isZoomed) return;
    if (transformation.value == Matrix4.identity()) return;
    _fly(Matrix4.identity());
  }

  void _fly(Matrix4 target) {
    _flight = Matrix4Tween(
      begin: transformation.value,
      end: target,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
    animation.forward(from: 0);
  }

  Size get _viewport {
    final RenderObject? box = context.findRenderObject();
    return box is RenderBox && box.hasSize ? box.size : Size.zero;
  }

  Rect _contentIn(Size viewport) =>
      containedRect(widget.content, viewport) ?? Rect.zero;

  double _coverIn(Size viewport) {
    final Rect content = _contentIn(viewport);
    if (content.isEmpty) return _zoomMin;
    return max(
      viewport.width / content.width,
      viewport.height / content.height,
    );
  }

  Matrix4 _clamped(Matrix4 matrix, Size viewport) {
    final Rect content = _contentIn(viewport);
    if (content.isEmpty) return matrix;
    final double scale = matrix.getMaxScaleOnAxis();
    final Offset shift = MatrixUtils.transformPoint(matrix, Offset.zero);
    double axis(double shift, double begin, double end, double extent) {
      if ((end - begin) * scale <= extent) {
        return extent / 2 - (begin + end) / 2 * scale;
      }
      return shift.clamp(extent - end * scale, -begin * scale);
    }

    final Offset next = Offset(
      axis(shift.dx, content.left, content.right, viewport.width),
      axis(shift.dy, content.top, content.bottom, viewport.height),
    );
    if ((next - shift).distance < 0.01) return matrix;
    return matrix.clone()..setTranslationRaw(next.dx, next.dy, 0);
  }

  void _clamp() {
    final Matrix4 clamped = _clamped(transformation.value, _viewport);
    if (!identical(clamped, transformation.value)) {
      transformation.value = clamped;
    }
  }

  void _cycle() {
    if (widget.controller.isZoomed) return _fly(Matrix4.identity());
    final Size viewport = _viewport;
    final Rect content = _contentIn(viewport);
    final double cover = _coverIn(viewport);
    final double next = max(cover, 2.5).clamp(_zoomMin, cover * _zoomReach);
    Offset focus = _lastTap?.localPosition ?? viewport.center(Offset.zero);
    if (!content.contains(focus)) focus = content.center;
    final Offset shift = focus * (1 - next);
    _fly(
      Matrix4.identity()
        ..translateByDouble(shift.dx, shift.dy, 0, 1)
        ..scaleByDouble(next, next, 1, 1),
    );
  }

  Offset get _shift =>
      MatrixUtils.transformPoint(transformation.value, Offset.zero);

  void _translate(Offset scene) {
    transformation.value = transformation.value.clone()
      ..translateByDouble(scene.dx, scene.dy, 0, 1);
  }

  void _scaleBy(double change) {
    if (change == 1) return;
    final double current = transformation.value.getMaxScaleOnAxis();
    final double limit = _coverIn(_viewport) * _zoomReach;
    final double by = (current * change).clamp(_zoomMin, limit) / current;
    transformation.value = transformation.value.clone()
      ..scaleByDouble(by, by, by, 1);
  }

  void _scaleAround(double change, Offset focal) {
    final Offset before = transformation.toScene(focal);
    _scaleBy(change);
    _translate(transformation.toScene(focal) - before);
  }

  bool _canMove(Offset moved) =>
      moved.dx != 0 && !_pinned(Axis.horizontal, leading: moved.dx > 0);

  Offset? _panned;
  bool _fromTop = false;
  bool _fromBottom = false;

  bool _pinned(Axis axis, {required bool leading}) {
    final Size viewport = _viewport;
    final Rect content = _contentIn(viewport);
    final double scale = widget.controller.scale;
    final (
      double shift,
      double begin,
      double end,
      double extent,
    ) = switch (axis) {
      Axis.horizontal => (
        _shift.dx,
        content.left,
        content.right,
        viewport.width,
      ),
      Axis.vertical => (
        _shift.dy,
        content.top,
        content.bottom,
        viewport.height,
      ),
    };
    if (leading) return shift >= -scale * begin - _edgeSlack;
    return shift <= extent - scale * end + _edgeSlack;
  }

  void _onStart(ScaleStartDetails details) {
    _panned = _shift;
    _fromTop = _pinned(Axis.vertical, leading: true);
    _fromBottom = _pinned(Axis.vertical, leading: false);
  }

  void _onUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount != 1 || details.scale != 1) {
      _panned = null;
      return;
    }
    final Offset moved = _shift;
    if (widget.controller.isZoomed) {
      _panned = moved;
      return;
    }
    if (_panned case final Offset last) {
      final Offset spare = details.focalPointDelta - (moved - last);
      final bool allowed = spare.dy > 0
          ? _fromTop
          : spare.dy < 0 && _fromBottom;
      if (allowed) widget.onSpare?.call(spare);
    }
    _panned = moved;
  }

  void _onEnd(ScaleEndDetails details) {
    _panned = null;
    _settle();
    if (details.pointerCount > 0) {
      widget.onSpareCancel?.call();
    } else {
      widget.onSpareEnd?.call(details.velocity);
    }
  }

  _ZoomGesture? _gesture;
  double? _scaleStart;
  Offset? _reference;

  void _start(ScaleStartDetails details) {
    _onStart(details);
    coast.stop();
    _coasting = null;
    _gesture = null;
    _scaleStart = transformation.value.getMaxScaleOnAxis();
    _reference = transformation.toScene(details.localFocalPoint);
  }

  void _update(ScaleUpdateDetails details) {
    final _ZoomGesture kind = details.scale != 1
        ? _ZoomGesture.scale
        : _ZoomGesture.pan;
    _gesture = _gesture == _ZoomGesture.scale ? _gesture : kind;
    final Offset reference = _reference!;
    switch (_gesture!) {
      case _ZoomGesture.scale:
        final double scale = transformation.value.getMaxScaleOnAxis();
        _scaleBy(_scaleStart! * details.scale / scale);
        _translate(transformation.toScene(details.localFocalPoint) - reference);
        final Offset check = transformation.toScene(details.localFocalPoint);
        if ((check - reference).distance > 1e-9) _reference = check;
      case _ZoomGesture.pan:
        _translate(transformation.toScene(details.localFocalPoint) - reference);
        _reference = transformation.toScene(details.localFocalPoint);
    }
    _coastFocus = details.localFocalPoint;
    _onUpdate(details);
  }

  Offset _coastFocus = Offset.zero;

  void _end(ScaleEndDetails details) {
    _onEnd(details);
    _scaleStart = null;
    _reference = null;
    if (!widget.controller.isZoomed) return;
    switch (_gesture) {
      case _ZoomGesture.pan:
        final Offset velocity = details.velocity.pixelsPerSecond;
        if (velocity.distance < kMinFlingVelocity) return;
        final Offset from = _shift;
        final Offset to = Offset(
          FrictionSimulation(_zoomFriction, from.dx, velocity.dx).finalX,
          FrictionSimulation(_zoomFriction, from.dy, velocity.dy).finalX,
        );
        final Animation<Offset> drift = Tween<Offset>(
          begin: from,
          end: to,
        ).chain(CurveTween(curve: Curves.decelerate)).animate(coast);
        _coasting = () =>
            transformation.value = transformation.value.clone()
              ..setTranslationRaw(drift.value.dx, drift.value.dy, 0);
        _glide(_coastTime(velocity.distance));
      case _ZoomGesture.scale:
        if (details.scaleVelocity.abs() < 0.1) return;
        final double from = transformation.value.getMaxScaleOnAxis();
        final double time = _coastTime(
          details.scaleVelocity.abs(),
          motionless: 0.1,
        );
        final Animation<double> swell = Tween<double>(
          begin: from,
          end: FrictionSimulation(
            _zoomFriction * kDefaultMouseScrollToScaleFactor,
            from,
            details.scaleVelocity / 10,
          ).x(time),
        ).chain(CurveTween(curve: Curves.decelerate)).animate(coast);
        final Offset focus = _coastFocus;
        _coasting = () => _scaleAround(
          swell.value / transformation.value.getMaxScaleOnAxis(),
          focus,
        );
        _glide(time);
      case null:
        break;
    }
  }

  double _coastTime(double velocity, {double motionless = 10}) =>
      log(motionless / velocity) / log(_zoomFriction / 100);

  void _glide(double seconds) {
    coast.duration = Duration(milliseconds: (seconds * 1000).round());
    coast.forward(from: 0);
  }

  void _onSignal(PointerSignalEvent event) {
    final Offset local = event.localPosition;
    final ScaleStartDetails start = ScaleStartDetails(
      focalPoint: event.position,
      localFocalPoint: local,
    );
    final double change;
    switch (event) {
      case PointerScrollEvent(kind: PointerDeviceKind.trackpad):
        final Offset delta = PointerEvent.transformDeltaViaPositions(
          untransformedEndPosition: event.position + event.scrollDelta,
          untransformedDelta: event.scrollDelta,
          transform: event.transform,
        );
        _onStart(start);
        _translate(
          transformation.toScene(local - delta) - transformation.toScene(local),
        );
        _onUpdate(
          ScaleUpdateDetails(
            focalPoint: event.position - event.scrollDelta,
            localFocalPoint: local - delta,
            focalPointDelta: -delta,
          ),
        );
        _onEnd(ScaleEndDetails());
        return;
      case PointerScrollEvent(:final Offset scrollDelta):
        if (scrollDelta.dy == 0) return;
        change = exp(-scrollDelta.dy / kDefaultMouseScrollToScaleFactor);
      case PointerScaleEvent(:final double scale):
        change = scale;
      default:
        return;
    }
    _onStart(start);
    _scaleAround(change, local);
    _onUpdate(
      ScaleUpdateDetails(
        focalPoint: event.position,
        localFocalPoint: local,
        scale: change,
      ),
    );
    _onEnd(ScaleEndDetails());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onDoubleTapDown: (details) => _lastTap = details,
      onDoubleTap: _cycle,
      child: Listener(
        onPointerSignal: _onSignal,
        child: RawGestureDetector(
          behavior: HitTestBehavior.opaque,
          gestures: {
            ZoomGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<ZoomGestureRecognizer>(
                  () => ZoomGestureRecognizer(
                    canMove: _canMove,
                    debugOwner: this,
                  ),
                  (recognizer) => recognizer
                    ..dragStartBehavior = DragStartBehavior.start
                    ..gestureSettings = MediaQuery.maybeGestureSettingsOf(
                      context,
                    )
                    ..onStart = _start
                    ..onUpdate = _update
                    ..onEnd = _end,
                ),
          },
          child: ListenableBuilder(
            listenable: transformation,
            builder: (context, child) =>
                Transform(transform: transformation.value, child: child),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class ZoomGestureRecognizer extends ScaleGestureRecognizer {
  ZoomGestureRecognizer({required this.canMove, super.debugOwner});

  final bool Function(Offset moved) canMove;

  final Map<int, Offset> _positions = {};
  Offset? _focal;
  Offset _travel = Offset.zero;

  @override
  void handleEvent(PointerEvent event) {
    switch (event) {
      case PointerDownEvent():
        if (_positions.isEmpty) _travel = Offset.zero;
        _positions[event.pointer] = event.position;
      case PointerMoveEvent(synthesized: false):
        _positions[event.pointer] = event.position;
      case PointerUpEvent() || PointerCancelEvent():
        _positions.remove(event.pointer);
      default:
        break;
    }
    final Offset? before = _focal;
    _focal = _positions.isEmpty
        ? null
        : _positions.values.reduce((a, b) => a + b) /
              _positions.length.toDouble();
    if (event is PointerMoveEvent && before != null && _focal != null) {
      final Offset moved = _focal! - before;
      _travel += moved;
      final bool slid =
          _travel.distance > computeHitSlop(event.kind, gestureSettings);
      if (_positions.length > 1 || (slid && canMove(moved))) {
        acceptGesture(event.pointer);
      }
    }
    super.handleEvent(event);
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    _positions.clear();
    super.didStopTrackingLastPointer(pointer);
  }
}
