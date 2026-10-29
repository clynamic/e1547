import 'package:flutter/material.dart';

const double kContentPadding = 4;

const double defaultAppBarTopPadding = kContentPadding;
const double defaultAppBarHorizontalPadding = kContentPadding * 2;
const double defaultAppBarHeight = kToolbarHeight + defaultAppBarTopPadding;

const EdgeInsets defaultListPadding = EdgeInsets.symmetric(
  horizontal: kContentPadding,
  vertical: kContentPadding * 2,
);

const double defaultActionListBottomHeight = kBottomNavigationBarHeight + 24;

final EdgeInsets defaultActionListPadding = defaultListPadding.copyWith(
  bottom: defaultActionListBottomHeight,
);

class SliverBottomInsetPadding extends StatelessWidget {
  const SliverBottomInsetPadding({
    super.key,
    this.padding = EdgeInsets.zero,
    required this.sliver,
  });

  final EdgeInsets padding;
  final Widget sliver;

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: padding.copyWith(
      bottom: padding.bottom + MediaQuery.paddingOf(context).bottom,
    ),
    sliver: sliver,
  );
}
