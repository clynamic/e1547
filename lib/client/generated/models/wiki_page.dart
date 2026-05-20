// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'wiki_page.g.dart';

@JsonSerializable()
class WikiPage {
  const WikiPage({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.body,
    required this.isLocked,
    required this.isDeleted,
    required this.otherNames,
    required this.createdAt,
    required this.updatedAt,
    this.creatorName,
    this.updaterId,
    this.parent,
    this.categoryId,
  });
  
  factory WikiPage.fromJson(Map<String, Object?> json) => _$WikiPageFromJson(json);
  
  /// The unique ID of the wiki page
  final int id;

  /// The ID of the user who created the wiki page
  @JsonKey(name: 'creator_id')
  final int creatorId;

  /// The username of the creator
  @JsonKey(name: 'creator_name')
  final String? creatorName;

  /// The title of the wiki page
  final String title;

  /// The body content of the wiki page
  final String body;

  /// Whether the wiki page is locked
  @JsonKey(name: 'is_locked')
  final bool isLocked;

  /// Whether the wiki page is deleted
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;

  /// Alternative names for the wiki page
  @JsonKey(name: 'other_names')
  final List<String> otherNames;

  /// The ID of the user who last updated the wiki page
  @JsonKey(name: 'updater_id')
  final int? updaterId;

  /// The parent wiki page title for redirects
  final String? parent;

  /// The tag category ID associated with the wiki page
  @JsonKey(name: 'category_id')
  final int? categoryId;

  /// When the wiki page was created
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// When the wiki page was last updated
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Map<String, Object?> toJson() => _$WikiPageToJson(this);
}
