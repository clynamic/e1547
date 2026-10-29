import 'package:deep_pick/deep_pick.dart';
import 'package:e1547/set/set.dart';

abstract final class E621PostSet {
  static PostSet fromJson(dynamic json) => pick(json).letOrThrow(
    (pick) => PostSet(
      id: pick('id').asIntOrThrow(),
      name: pick('name').asStringOrThrow(),
      shortname: pick('shortname').asStringOrThrow(),
      description: pick('description').asStringOrNull() ?? '',
      public: pick('is_public').asBoolOrThrow(),
      creatorId: pick('creator_id').asIntOrThrow(),
      postIds: pick('post_ids').asListOrThrow((pick) => pick.asIntOrThrow()),
      postCount: pick('post_count').asIntOrThrow(),
      createdAt: pick('created_at').asDateTimeOrThrow(),
      updatedAt: pick('updated_at').asDateTimeOrThrow(),
    ),
  );
}
