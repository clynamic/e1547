import 'package:e1547/post/post.dart';
import 'package:flutter/material.dart';

class PostThumbnail extends StatelessWidget {
  const PostThumbnail({
    super.key,
    required this.id,
    required this.height,
    this.current = false,
  });

  final int id;
  final double height;
  final bool current;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.05),
          ),
          PostCover(id: id),
          if (current)
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
          if (!current)
            Material(
              type: MaterialType.transparency,
              child: InkWell(onTap: () => pushPostLoadingPage(context, id)),
            ),
        ],
      ),
    ),
  );
}
