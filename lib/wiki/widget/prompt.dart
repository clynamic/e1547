import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/wiki/wiki.dart';
import 'package:flutter/material.dart';

Future<void> showWikiPrompt({
  required BuildContext context,
  required Wiki wiki,
}) => showPrompt<void>(
  context,
  dialogWidth: 800,
  header: (context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    child: InkWell(
      onTap: () {
        if (popDialog(context)) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  PostsPage(params: PostParams(tags: wiki.title)),
            ),
          );
        }
      },
      child: Text(
        tagToName(wiki.title),
        style: Theme.of(context).textTheme.titleLarge,
        softWrap: true,
      ),
    ),
  ),
  body: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: WikiInfo(wiki: wiki),
  ),
);
