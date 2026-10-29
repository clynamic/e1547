import 'package:freezed_annotation/freezed_annotation.dart';

part 'set.freezed.dart';
part 'set.g.dart';

@freezed
abstract class PostSet with _$PostSet {
  const factory PostSet({
    required int id,
    required String name,
    required String shortname,
    required String description,
    required bool public,
    required int creatorId,
    required List<int> postIds,
    required int postCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PostSet;

  factory PostSet.fromJson(dynamic json) => _$PostSetFromJson(json);
}
