import 'package:e1547/app/app.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/settings/settings.dart';
import 'package:flutter/material.dart';

enum ShellTab {
  browse('Browse', Icons.explore),
  search('Search', Icons.search),
  library('Library', Icons.collections_bookmark),
  you('You', Icons.person);

  const ShellTab(this.label, this.icon);

  final String label;
  final IconData icon;

  Widget build(BuildContext context) => switch (this) {
    ShellTab.browse => const BrowsePage(),
    ShellTab.search => const PostsPage(),
    ShellTab.library => const LibraryPage(),
    ShellTab.you => const SettingsPage(),
  };
}
