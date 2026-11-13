import 'package:e1547/markup/markup.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class DTextFold extends StatefulWidget {
  const DTextFold({super.key, required this.text});

  final String text;

  @override
  State<DTextFold> createState() => _DTextFoldState();
}

class _DTextFoldState extends State<DTextFold> {
  bool expanded = false;
  bool long = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool folded = long && !expanded;
    final double fontSize = DefaultTextStyle.of(context).style.fontSize ?? 14;
    const double lineHeight = 22;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTextStyle.merge(
          style: TextStyle(height: lineHeight / fontSize),
          child: Stack(
            children: [
              HeightLimit(
                maxHeight: expanded ? double.infinity : lineHeight * 15,
                tolerance: lineHeight * 4,
                onOverflow: (overflows) {
                  if (mounted && !expanded && overflows != long) {
                    setState(() => long = overflows);
                  }
                },
                child: DText(widget.text),
              ),
              if (folded)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: lineHeight,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            theme.cardColor.withValues(alpha: 0),
                            theme.cardColor,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (long)
          InkWell(
            onTap: () => setState(() => expanded = !expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                expanded ? 'Show less' : 'Show more',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ),
          ),
      ],
    );
  }
}
