import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/user/user.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String postFileWords(Post post) => [
  post.ext.toUpperCase(),
  '${post.width} × ${post.height}',
  filesize(post.size, 1),
].join(' · ');

class PostDetailsSection extends StatelessWidget {
  const PostDetailsSection({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final Color dim = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.55);
    final List<(String, Widget)> rows = [
      (
        'Rating',
        TagGesture(
          tag: 'rating:${post.rating.name}',
          child: Text(post.rating.title),
        ),
      ),
      ('Favorites', Text('${post.favCount}')),
      ('File', Text(postFileWords(post))),
      ('Posted', Text(DateFormatting.day(post.createdAt.toLocal()))),
      if (post.updatedAt case final DateTime updated?)
        ('Updated', Text(DateFormatting.day(updated.toLocal()))),
      (
        'ID',
        GestureDetector(
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: post.id.toString()));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 1),
                content: Text('Copied post id #${post.id}'),
              ),
            );
          },
          child: Text('#${post.id}'),
        ),
      ),
      (
        'Uploader',
        InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UserLoadingPage(
                post.uploaderId,
                initalPage: UserPageSection.uploads,
              ),
            ),
          ),
          child: Text(post.uploaderName ?? '#${post.uploaderId}'),
        ),
      ),
    ];
    return PostDetailSection(
      section: PostSection.details,
      label: 'Details',
      summary: [
        post.rating.title,
        postFileWords(post),
        DateFormatting.day(post.createdAt.toLocal()),
      ].join(' · '),
      child: Column(
        spacing: 8,
        children: [
          for (final (String label, Widget value) in rows)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                SizedBox(
                  width: 96,
                  child: Text(label, style: TextStyle(color: dim)),
                ),
                Expanded(
                  child: Align(alignment: Alignment.centerLeft, child: value),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
