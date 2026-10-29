import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

const double pickerHeaderHeight = 72;

class PickerHeader extends StatelessWidget {
  const PickerHeader({
    super.key,
    required this.label,
    required this.picking,
    required this.onToggle,
    this.leading,
  });

  final String label;
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            children: [
              ?leading,
              Material(
                color: picking ? theme.cardColor : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                child: InkWell(
                  onTap: onToggle,
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 48,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 4,
                        children: [
                          Text(
                            label,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
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
                    ),
                  ),
                ),
              ),
            ],
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
    this.child,
  });

  final String title;
  final Widget subtitle;
  final bool selected;
  final VoidCallback onTap;
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              Row(
                children: [
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

class PickerTiles extends StatelessWidget {
  const PickerTiles({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final Color empty = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.06);
    return Row(
      spacing: 6,
      children: [
        for (int i = 0; i < 4; i++)
          Expanded(
            child: SizedBox(
              height: 64,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: i < children.length
                    ? children[i]
                    : ColoredBox(color: empty),
              ),
            ),
          ),
      ],
    );
  }
}
