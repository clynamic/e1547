import 'package:e1547/post/post.dart';
import 'package:flutter/material.dart';

class PostFamilySection extends StatelessWidget {
  const PostFamilySection({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final int? parentId = post.relationships.parentId;
    final List<int> children = (post.relationships.hasActiveChildren ?? true)
        ? post.relationships.children
        : const [];
    if (parentId == null && children.isEmpty) return const SizedBox.shrink();
    final List<(int, String)> family = [
      if (parentId != null) (parentId, 'Parent'),
      for (final int child in children) (child, 'Child'),
    ];
    final Color dim = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.6);
    return PostDetailSection(
      section: PostSection.family,
      label: 'Parent & children',
      summary: [
        if (parentId != null) 'Parent',
        if (children.isNotEmpty)
          '${children.length} ${children.length == 1 ? 'child' : 'children'}',
      ].join(' · '),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            for (final (int id, String label) in family)
              SizedBox(
                width: 88,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    PostThumbnail(id: id, height: 88),
                    Text(label, style: TextStyle(fontSize: 12, color: dim)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
