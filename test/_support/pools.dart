import 'package:e1547/pool/pool.dart';
import 'package:e1547/set/set.dart';

Pool samplePool({
  int id = 1,
  String name = 'river_story',
  PoolCategory category = PoolCategory.series,
  bool active = true,
  List<int> postIds = const [1, 2, 3],
}) => Pool(
  id: id,
  name: name,
  createdAt: DateTime(2026, 9, 2),
  updatedAt: DateTime(2026, 10, 23),
  description: '',
  postIds: postIds,
  postCount: postIds.length,
  active: active,
  category: category,
);

Map<String, Object?> poolJson(
  int id,
  String name, {
  String category = 'series',
  List<int> posts = const [],
}) => {
  'id': id,
  'name': name,
  'created_at': '2026-09-01T12:00:00.000-04:00',
  'updated_at': '2026-10-23T12:00:00.000-04:00',
  'creator_id': 1,
  'description': '',
  'is_active': true,
  'category': category,
  'post_ids': posts,
  'post_count': posts.length,
};

Map<String, Object?> setJson(
  int id,
  String name, {
  required int creator,
  bool public = true,
  int count = 2,
}) => {
  'id': id,
  'name': name,
  'shortname': name,
  'description': '',
  'is_public': public,
  'creator_id': creator,
  'post_ids': List.generate(count, (i) => i + 1),
  'post_count': count,
  'created_at': '2026-09-01T12:00:00.000-04:00',
  'updated_at': '2026-10-23T12:00:00.000-04:00',
};

PostSet sampleSet({bool public = true, int creator = 7, int count = 2310}) =>
    PostSet(
      id: 1,
      name: 'reference',
      shortname: 'reference',
      description: '',
      public: public,
      creatorId: creator,
      postIds: const [],
      postCount: count,
      createdAt: DateTime(2026, 9, 2),
      updatedAt: DateTime(2026, 10, 23),
    );
