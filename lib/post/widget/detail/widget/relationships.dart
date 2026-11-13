import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class RelationshipDisplay extends StatelessWidget {
  const RelationshipDisplay({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final int? parentId = post.relationships.parentId;
    final List<int> children = (post.relationships.hasActiveChildren ?? true)
        ? post.relationships.children
        : const [];
    if (parentId == null && children.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (parentId != null) ...[
          const RelationHeader(title: 'Parent'),
          PostRelationTile(id: parentId),
          const Divider(),
        ],
        if (children.isNotEmpty) ...[
          RelationHeader(title: 'Children', count: children.length),
          SizedBox(
            height: postRelationPreviewSize,
            child: ScrollEdgeFade(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: children.length,
                itemBuilder: (context, index) => PostRelationPreview(
                  id: children[index],
                  onTap: () => pushPostGallery(
                    context,
                    params: PostParams(tags: 'parent:${post.id} order:id'),
                    initialPostId: children[index],
                  ),
                ),
              ),
            ),
          ),
          const Divider(),
        ],
      ],
    );
  }
}
