import 'package:e1547/post/post.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Builds a post with neutral values, so a test can vary only the fields it
/// asserts on.
Post samplePost({
  int id = 1,
  Map<String, List<String>> tags = const {},
  String? file,
  String? preview,
  Relationships relationships = const Relationships(
    parentId: null,
    hasChildren: false,
    hasActiveChildren: null,
    children: [],
  ),
  int score = 0,
  int favCount = 0,
  bool isFavorited = false,
  Rating rating = Rating.s,
  String ext = 'jpg',
  int width = 100,
  int height = 100,
  int size = 1000,
  int uploaderId = 1,
  String? uploaderName = 'uploader',
  List<int>? pools,
  bool isDeleted = false,
}) => Post(
  id: id,
  file: file,
  sample: null,
  preview: preview,
  width: width,
  height: height,
  ext: ext,
  size: size,
  variants: null,
  tags: tags,
  uploaderId: uploaderId,
  uploaderName: uploaderName,
  createdAt: DateTime.utc(2020),
  updatedAt: null,
  score: score,
  vote: null,
  isDeleted: isDeleted,
  rating: rating,
  favCount: favCount,
  isFavorited: isFavorited,
  commentCount: 0,
  description: '',
  sources: const [],
  pools: pools,
  relationships: relationships,
);

int shownPost(WidgetTester tester) {
  final List<Element> pages = find.byType(PostDetail).evaluate().toList();
  double away(Element page) =>
      tester.getTopLeft(find.byWidget(page.widget)).dx.abs();
  pages.sort((a, b) => away(a).compareTo(away(b)));
  return (pages.first.widget as PostDetail).post.id;
}
