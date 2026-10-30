import 'package:e1547/markup/markup.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class PostDescription extends StatefulWidget {
  const PostDescription({super.key, required this.post});

  final Post post;

  static const double previewHeight = 22 * 3;

  @override
  State<PostDescription> createState() => _PostDescriptionState();
}

class _PostDescriptionState extends State<PostDescription> {
  bool expanded = false;
  bool long = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTextStyle.merge(
          style: TextStyle(
            fontSize: 15,
            height: 22 / 15,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
          ),
          child: HeightLimit(
            maxHeight: expanded
                ? double.infinity
                : PostDescription.previewHeight,
            onOverflow: (overflows) {
              if (mounted && !expanded && overflows != long) {
                setState(() => long = overflows);
              }
            },
            child: DText(widget.post.description),
          ),
        ),
        if (long)
          InkWell(
            onTap: () => setState(() => expanded = !expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                expanded ? 'Show less' : 'Show more',
                style: TextStyle(
                  fontSize: 15,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
