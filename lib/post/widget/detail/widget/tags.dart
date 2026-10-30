import 'package:e1547/post/post.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

const List<TagCategory> postTagOrder = [
  TagCategory.artist,
  TagCategory.contributor,
  TagCategory.copyright,
  TagCategory.character,
  TagCategory.species,
  TagCategory.general,
  TagCategory.meta,
  TagCategory.lore,
  TagCategory.invalid,
];

class PostTagsSection extends StatelessWidget {
  const PostTagsSection({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final List<(TagCategory, List<String>)> groups = [
      for (final TagCategory category in postTagOrder)
        if (post.tags[category.name] case final tags? when tags.isNotEmpty)
          (category, tags),
    ];
    if (groups.isEmpty) return const SizedBox.shrink();
    return PostDetailSection(
      section: PostSection.tags,
      label: 'Tags',
      count: groups.fold<int>(0, (sum, group) => sum + group.$2.length),
      summary: groups.take(3).map((e) => tagToName(e.$2.first)).join(' · '),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 14,
        children: [
          for (final (TagCategory category, List<String> tags) in groups)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                PostSectionTitle(label: category.name, count: tags.length),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    for (final String tag in tags)
                      PostTagChip(tag: tag, category: category),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class PostTagChip extends StatelessWidget {
  const PostTagChip({super.key, required this.tag, required this.category});

  final String tag;
  final TagCategory category;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onLongPress: () => showTagSearchPrompt(context: context, tag: tag),
    onSecondaryTap: () => showTagSearchPrompt(context: context, tag: tag),
    child: QueryChip(
      term: tag,
      category: category,
      selected: false,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PostsPage(params: PostParams(tags: tag)),
        ),
      ),
    ),
  );
}
