import 'package:e1547/markup/markup.dart';
import 'package:e1547/post/post.dart';
import 'package:flutter/material.dart';

class DescriptionDisplay extends StatelessWidget {
  const DescriptionDisplay({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) => HiddenWidget(
    show: post.description.trim().isNotEmpty,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DTextFold(text: post.description),
                ),
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    ),
  );
}
