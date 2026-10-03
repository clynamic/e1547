import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';

class FileDisplay extends StatelessWidget {
  const FileDisplay({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
            AppLocalizations.of(context).detailFile,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TagGesture(
                tag: 'rating:${post.rating.name}',
                child: Text(localizedRatingName(context, post.rating)),
              ),
              Text('${post.width} x ${post.height}'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localizedDateTime(context, post.createdAt.toLocal())),
              Text(filesize(post.size, 1)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (post.updatedAt != null)
                Text(localizedDateTime(context, post.updatedAt!.toLocal())),
              TagGesture(tag: 'type:${post.ext}', child: Text(post.ext)),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
