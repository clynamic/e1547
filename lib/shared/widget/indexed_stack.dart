import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class AnimatedIndexedStack extends StatefulWidget {
  const AnimatedIndexedStack({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 300),
  });

  final int index;
  final List<Widget> children;
  final Duration duration;

  @override
  State<AnimatedIndexedStack> createState() => _AnimatedIndexedStackState();
}

class _AnimatedIndexedStackState extends State<AnimatedIndexedStack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
    value: 1,
  );
  late int _current = widget.index;
  int? _previous;

  @override
  void didUpdateWidget(covariant AnimatedIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.duration;
    if (widget.index == _current) return;
    _previous = _current;
    _current = widget.index;
    _controller.forward(from: 0).whenComplete(() {
      if (mounted) setState(() => _previous = null);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _child(int index) {
    final bool current = index == _current;
    final bool leaving = index == _previous;
    return Offstage(
      key: ValueKey(index),
      offstage: !current && !leaving,
      child: TickerMode(
        enabled: current,
        child: HeroMode(
          enabled: current,
          child: IgnorePointer(
            ignoring: !current,
            child: FadeThroughTransition(
              animation: current ? _controller : kAlwaysCompleteAnimation,
              secondaryAnimation: leaving
                  ? _controller
                  : kAlwaysDismissedAnimation,
              child: widget.children[index],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      for (int i = 0; i < widget.children.length; i++)
        if (i != _current) _child(i),
      _child(_current),
    ],
  );
}
