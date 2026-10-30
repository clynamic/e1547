import 'package:flutter/material.dart';

Color wellColor(ThemeData theme) => Color.alphaBlend(
  theme.colorScheme.onSurface.withValues(alpha: 0.05),
  theme.cardColor,
);

class SheetPanel extends StatelessWidget {
  const SheetPanel({
    super.key,
    required this.title,
    required this.onClose,
    required this.child,
    this.icon = Icons.keyboard,
    this.tooltip = 'Close',
    this.trailing,
  });

  final String title;
  final VoidCallback onClose;
  final Widget child;
  final IconData icon;
  final String tooltip;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: Color.alphaBlend(
        Colors.black.withValues(alpha: 0.15),
        theme.cardColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 44,
            padding: const EdgeInsets.fromLTRB(4, 0, 8, 0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
                ),
              ),
            ),
            child: Row(
              spacing: 8,
              children: [
                IconButton(
                  tooltip: tooltip,
                  onPressed: onClose,
                  icon: Icon(icon, size: 20),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (trailing case final Widget trailing?)
                  Expanded(child: trailing),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }
}
