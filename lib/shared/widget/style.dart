import 'dart:ui';

import 'package:flutter/material.dart';

class AppStyle extends ThemeExtension<AppStyle> {
  const AppStyle({
    required this.outline,
    required this.skeleton,
    required this.smallRadius,
    required this.largeRadius,
  });

  factory AppStyle.from(ThemeData theme) => AppStyle(
    outline: theme.colorScheme.onSurface.withValues(alpha: 0.3),
    skeleton: theme.colorScheme.onSurface.withValues(alpha: 0.05),
    smallRadius: 4,
    largeRadius: 8,
  );

  factory AppStyle.of(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.extension<AppStyle>() ?? AppStyle.from(theme);
  }

  final Color outline;
  final Color skeleton;
  final double smallRadius;
  final double largeRadius;

  @override
  AppStyle copyWith({
    Color? outline,
    Color? skeleton,
    double? smallRadius,
    double? largeRadius,
  }) => AppStyle(
    outline: outline ?? this.outline,
    skeleton: skeleton ?? this.skeleton,
    smallRadius: smallRadius ?? this.smallRadius,
    largeRadius: largeRadius ?? this.largeRadius,
  );

  @override
  AppStyle lerp(AppStyle? other, double t) {
    if (other == null) return this;
    return AppStyle(
      outline: Color.lerp(outline, other.outline, t)!,
      skeleton: Color.lerp(skeleton, other.skeleton, t)!,
      smallRadius: lerpDouble(smallRadius, other.smallRadius, t)!,
      largeRadius: lerpDouble(largeRadius, other.largeRadius, t)!,
    );
  }
}
