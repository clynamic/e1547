import 'package:e1547/post/post.dart';
import 'package:flutter/material.dart';

class HotPage extends StatelessWidget {
  const HotPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const PostsPage(params: PostParams(tags: 'order:rank'));
}
