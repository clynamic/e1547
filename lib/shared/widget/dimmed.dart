import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

double smallIconSize(BuildContext context) => 18;

Color dimTextColor(BuildContext context, [double opacity = 0.35]) => Theme.of(
  context,
).textTheme.bodyMedium!.color!.withAlpha((opacity * 255).ceil());

class Dimmed extends StatelessWidget {
  const Dimmed({super.key, required this.child, this.opacity = 0.35});

  final Widget child;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: Theme.of(context).iconTheme.copyWith(
        color: dimTextColor(context, opacity),
        size: smallIconSize(context),
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: dimTextColor(context, opacity)),
        child: child,
      ),
    );
  }
}

class SliverDim extends StatelessWidget {
  const SliverDim({super.key, required this.dimmed, required this.sliver});

  final bool dimmed;
  final Widget sliver;

  @override
  Widget build(BuildContext context) => SliverIgnorePointer(
    ignoring: dimmed,
    sliver: SliverAnimatedOpacity(
      opacity: dimmed ? 0.45 : 1,
      duration: defaultAnimationDuration,
      sliver: sliver,
    ),
  );
}
