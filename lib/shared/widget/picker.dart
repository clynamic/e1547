import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

const double pickerHeaderHeight = 72;

class PickerHeader extends StatelessWidget {
  const PickerHeader({
    super.key,
    required this.label,
    required this.picking,
    required this.onToggle,
    this.subtitle,
    this.leading,
  });

  final String label;
  final String? subtitle;
  final bool picking;
  final VoidCallback onToggle;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
      child: SizedBox(
        height: pickerHeaderHeight,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
          child: Material(
            type: MaterialType.transparency,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  ?leading,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 4,
                          children: [
                            Text(
                              label,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                height: subtitle == null ? null : 1.1,
                              ),
                            ),
                            AnimatedRotation(
                              turns: picking ? 0.5 : 0,
                              duration: defaultAnimationDuration,
                              child: Icon(
                                Icons.expand_more,
                                color: picking
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface.withValues(
                                        alpha: 0.7,
                                      ),
                              ),
                            ),
                          ],
                        ),
                        if (subtitle case final subtitle?)
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.1,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PickerList extends StatelessWidget {
  const PickerList({super.key, required this.picking, required this.children});

  final bool picking;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => AnimatedSize(
    duration: defaultAnimationDuration,
    curve: Curves.easeOutCubic,
    alignment: Alignment.topCenter,
    child: picking
        ? Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: Column(spacing: 8, children: children),
          )
        : const SizedBox(width: double.infinity),
  );
}

class PickerCard extends StatelessWidget {
  const PickerCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    required this.icon,
    this.child,
  });

  final String title;
  final Widget subtitle;
  final bool selected;
  final VoidCallback onTap;
  final IconData icon;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color accent = theme.colorScheme.primary;
    return Material(
      color: selected
          ? accent.withValues(alpha: 0.08)
          : Color.alphaBlend(
              theme.colorScheme.onSurface.withValues(alpha: 0.03),
              theme.canvasColor,
            ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: selected ? accent : Colors.transparent),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 14, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              Row(
                spacing: 14,
                children: [
                  SizedBox.square(
                    dimension: 48,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: selected
                            ? accent.withValues(alpha: 0.14)
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.06,
                              ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        icon,
                        size: 26,
                        color: selected
                            ? accent
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.75,
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 2,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: selected ? accent : null,
                          ),
                        ),
                        DefaultTextStyle.merge(
                          style: TextStyle(
                            fontSize: 13,
                            color: dimTextColor(context),
                          ),
                          child: subtitle,
                        ),
                      ],
                    ),
                  ),
                  if (selected) Icon(Icons.check, color: accent),
                ],
              ),
              ?child,
            ],
          ),
        ),
      ),
    );
  }
}
