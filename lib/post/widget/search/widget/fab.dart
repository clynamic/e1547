import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

class PostsPageFab extends StatelessWidget {
  const PostsPageFab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PostParamsController>();
    return SearchPromptFab(
      tags: controller.value.toQuery(),
      onSubmit: (value) =>
          controller.update((p) => p.copyWith(tags: value['tags'])),
      filters: [
        PrimaryFilterConfig(
          filter: TagSearchFilterTag(tag: 'tags', name: t('Tags')),
          filters: [PostParams.tagsFilter],
        ),
      ],
    );
  }
}
