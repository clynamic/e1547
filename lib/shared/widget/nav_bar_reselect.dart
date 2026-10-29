import 'package:flutter/material.dart';

class NavBarReselectController {
  Future<void> Function()? handler;

  Future<void> reselect() => handler?.call() ?? Future<void>.value();
}

class NavBarReselect extends InheritedWidget {
  const NavBarReselect({
    super.key,
    required this.controller,
    required super.child,
  });

  final NavBarReselectController controller;

  static NavBarReselectController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NavBarReselect>()?.controller;

  @override
  bool updateShouldNotify(NavBarReselect oldWidget) =>
      oldWidget.controller != controller;
}
