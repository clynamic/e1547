import 'dart:async';

import 'package:flutter/widgets.dart';

const Duration typingPause = Duration(milliseconds: 300);

class Debounced<T> extends StatefulWidget {
  const Debounced({
    super.key,
    required this.value,
    required this.builder,
    this.delay = typingPause,
  });

  final T value;
  final Duration delay;
  final Widget Function(BuildContext context, T value) builder;

  @override
  State<Debounced<T>> createState() => _DebouncedState<T>();
}

class _DebouncedState<T> extends State<Debounced<T>> {
  late T value = widget.value;
  Timer? timer;

  @override
  void didUpdateWidget(covariant Debounced<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == value) {
      timer?.cancel();
      return;
    }
    timer?.cancel();
    timer = Timer(widget.delay, () => setState(() => value = widget.value));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, value);
}
