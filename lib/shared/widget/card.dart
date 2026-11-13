import 'package:flutter/material.dart';

class ColoredCard extends StatelessWidget {
  const ColoredCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.color,
    this.onTap,
    this.onLongPress,
    this.onSecondaryTap,
    this.trailing,
    this.padding = const EdgeInsets.only(
      top: 4,
      bottom: 4,
      right: 10,
      left: stripeWidth + 6,
    ),
  });

  /// The content has to clear this width.
  static const double stripeWidth = 5;

  final Widget child;
  final Color? backgroundColor;
  final Color? color;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onSecondaryTap;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(2),
    child: PressBuilder(
      onTap: onTap,
      onLongPress: onLongPress,
      onSecondaryTap: onSecondaryTap,
      builder: _body,
    ),
  );

  Widget _body(BuildContext context, bool pressed) {
    final baseColor = backgroundColor ?? Theme.of(context).cardColor;
    final brightness = Theme.of(context).brightness;
    final pressedColor = Color.lerp(
      baseColor,
      brightness == Brightness.dark ? Colors.white : Colors.black,
      0.1,
    )!;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: pressed ? pressedColor : baseColor,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Padding(padding: padding, child: child),
              ),
              if (trailing case final trailing?) trailing,
            ],
          ),
          // Stacking gives the stripe the content's height rather than a
          // fixed one.
          if (color case final stripeColor?)
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              width: ColoredCard.stripeWidth,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: stripeColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PressBuilder extends StatefulWidget {
  const PressBuilder({
    super.key,
    required this.builder,
    this.onTap,
    this.onLongPress,
    this.onSecondaryTap,
  });

  final Widget Function(BuildContext context, bool pressed) builder;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onSecondaryTap;

  @override
  State<PressBuilder> createState() => _PressBuilderState();
}

class _PressBuilderState extends State<PressBuilder> {
  bool _pressed = false;
  bool _held = false;
  int _pressToken = 0;

  void _press() {
    setState(() => _pressed = true);
    final token = ++_pressToken;
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted && _pressToken == token && !_held) {
        setState(() => _pressed = false);
      }
    });
  }

  void _cancel() => setState(() => _pressed = false);

  void _hold() {
    _held = true;
    setState(() => _pressed = true);
  }

  void _release() {
    _held = false;
    _press();
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = widget.builder(context, _pressed);
    final bool tap = widget.onTap != null;
    final bool hold = widget.onLongPress != null;
    final bool secondary = widget.onSecondaryTap != null;
    if (!tap && !hold && !secondary) return child;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: tap ? (_) => _press() : null,
      onTapCancel: tap ? _cancel : null,
      onLongPress: widget.onLongPress,
      onLongPressDown: hold ? (_) => _hold() : null,
      onLongPressUp: hold ? _release : null,
      onLongPressCancel: hold ? _release : null,
      onSecondaryTap: widget.onSecondaryTap,
      onSecondaryTapDown: secondary ? (_) => _press() : null,
      onSecondaryTapCancel: secondary ? _cancel : null,
      child: child,
    );
  }
}
