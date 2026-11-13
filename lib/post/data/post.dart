import 'package:e1547/shared/shared.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost.dart';
part 'post.freezed.dart';
part 'post.g.dart';

abstract class PostSummary {
  int get id;
  String? get file;
  String? get sample;
  String? get preview;
  int get width;
  int get height;
  String get ext;
  int get size;
  Iterable<String> get allTags;
  int get uploaderId;
  String? get uploaderName;
  DateTime get createdAt;
  int get score;
  int? get vote;
  bool get isDeleted;
  Rating get rating;
  int get favCount;
  bool get isFavorited;
  int get commentCount;
  List<int>? get pools;
}

@freezed
abstract class Post with _$Post implements PostSummary {
  const factory Post({
    required int id,
    required String? file,
    required String? sample,
    required String? preview,
    required int width,
    required int height,
    required String ext,
    required int size,
    required Map<String, String?>? variants,
    required Map<String, List<String>> tags,
    required int uploaderId,
    required String? uploaderName,
    required DateTime createdAt,
    required DateTime? updatedAt,
    required int score,
    required int? vote,
    required bool isDeleted,
    required Rating rating,
    required int favCount,
    required bool isFavorited,
    required int commentCount,
    required String description,
    required List<String> sources,
    required List<int>? pools,
    required Relationships relationships,
  }) = _Post;

  const Post._();

  factory Post.fromJson(dynamic json) => _$PostFromJson(json);

  @override
  Iterable<String> get allTags => tags.values.expand((e) => e);
}

@freezed
abstract class PartialPost with _$PartialPost implements PostSummary {
  const factory PartialPost({
    required int id,
    required String? file,
    required String? sample,
    required String? preview,
    required int width,
    required int height,
    required String ext,
    required int size,
    required List<String> tags,
    required int uploaderId,
    required String? uploaderName,
    required DateTime createdAt,
    required int score,
    required int? vote,
    required bool isDeleted,
    required Rating rating,
    required int favCount,
    required bool isFavorited,
    required int commentCount,
    required List<int> pools,
  }) = _PartialPost;

  const PartialPost._();

  factory PartialPost.fromJson(dynamic json) => _$PartialPostFromJson(json);

  @override
  Iterable<String> get allTags => tags;
}

enum Rating { s, q, e }

@freezed
abstract class Relationships with _$Relationships {
  const factory Relationships({
    required int? parentId,
    required bool hasChildren,
    required bool? hasActiveChildren,
    required List<int> children,
  }) = _Relationships;

  factory Relationships.fromJson(dynamic json) => _$RelationshipsFromJson(json);
}
