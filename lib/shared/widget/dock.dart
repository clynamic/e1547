import 'dart:math';
import 'dart:ui';

import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

const double dockHeight = 56;
const double dockMargin = 12;
const double dockSpace = dockHeight + dockMargin;
const double dockFoldedMargin = 16;

class DockLayout extends StatelessWidget {
  const DockLayout({
    super.key,
    required this.content,
    required this.mark,
    required this.onTap,
    required this.child,
  });

  final Widget content;
  final Widget mark;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final NavBarVisibility? visibility = NavBarVisibilityScope.maybeOf(context);
    final double inset = NavBarInset.of(context);
    return Stack(
      children: [
        Positioned.fill(
          child: MediaQuery(
            data: media.copyWith(
              padding: media.padding.copyWith(
                bottom: media.padding.bottom + dockSpace,
              ),
            ),
            child: child,
          ),
        ),
        Positioned.fill(
          child: ListenableBuilder(
            listenable: visibility ?? const AlwaysStoppedAnimation(0),
            builder: (context, _) => _DockFrame(
              fold: visibility?.hidden ?? 0,
              bottom: media.padding.bottom,
              inset: inset,
              left: Handedness.of(context) == Handedness.left,
              content: content,
              mark: mark,
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}

class _DockFrame extends StatelessWidget {
  const _DockFrame({
    required this.fold,
    required this.bottom,
    required this.inset,
    required this.left,
    required this.content,
    required this.mark,
    required this.onTap,
  });

  final double fold;
  final double bottom;
  final double inset;
  final bool left;
  final Widget content;
  final Widget mark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = lerpDouble(
          constraints.maxWidth - dockMargin * 2,
          dockHeight,
          fold,
        )!;
        final double edge = lerpDouble(dockMargin, dockFoldedMargin, fold)!;
        final double lift = lerpDouble(
          bottom + dockMargin,
          bottom - inset + 24,
          fold,
        )!;
        final double markSize = lerpDouble(40, dockHeight, fold)!;
        final double contentOpacity = max(0, 1 - fold * 2);
        return Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: lift + dockHeight + 48,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 1 - fold,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0, 0.55],
                        colors: [
                          theme.scaffoldBackgroundColor.withValues(alpha: 0),
                          theme.scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: left ? edge : null,
              right: left ? null : edge,
              bottom: lift,
              width: width,
              height: dockHeight,
              child: Material(
                color: theme.cardColor,
                elevation: 6,
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onTap,
                  child: Padding(
                    padding: EdgeInsets.lerp(
                      left
                          ? const EdgeInsets.fromLTRB(8, 0, 16, 0)
                          : const EdgeInsets.fromLTRB(16, 0, 8, 0),
                      EdgeInsets.zero,
                      fold,
                    )!,
                    child: Row(
                      spacing: lerpDouble(12, 0, fold)!,
                      textDirection: left
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      children: [
                        Expanded(
                          child: contentOpacity > 0
                              ? Opacity(
                                  opacity: contentOpacity,
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: content,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                        SizedBox.square(
                          dimension: markSize,
                          child: Material(
                            color: theme.colorScheme.secondary,
                            borderRadius: BorderRadius.circular(
                              lerpDouble(4, 8, fold)!,
                            ),
                            child: IconTheme(
                              data: IconThemeData(
                                color: theme.colorScheme.onSecondary,
                              ),
                              child: Center(child: mark),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
