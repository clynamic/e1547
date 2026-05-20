// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_wiki_page_body_wiki_page.g.dart';

@JsonSerializable()
class UpdateWikiPageBodyWikiPage {
  const UpdateWikiPageBodyWikiPage({
    this.body,
    this.categoryId,
    this.editReason,
    this.parent,
    this.title,
    this.isLocked,
    this.isDeleted,
  });
  
  factory UpdateWikiPageBodyWikiPage.fromJson(Map<String, Object?> json) => _$UpdateWikiPageBodyWikiPageFromJson(json);
  
  /// The body content of the wiki page
  final String? body;

  /// The tag category ID
  @JsonKey(name: 'category_id')
  final int? categoryId;

  /// The reason for the edit
  @JsonKey(name: 'edit_reason')
  final String? editReason;

  /// The parent wiki page title (privileged+ only)
  final String? parent;

  /// The title of the wiki page (janitor+ only)
  final String? title;

  /// Whether the page is locked (janitor+ only)
  @JsonKey(name: 'is_locked')
  final bool? isLocked;

  /// Whether the page is deleted (janitor+ only)
  @JsonKey(name: 'is_deleted')
  final bool? isDeleted;

  Map<String, Object?> toJson() => _$UpdateWikiPageBodyWikiPageToJson(this);
}
