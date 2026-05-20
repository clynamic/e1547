// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'update_wiki_page_body_wiki_page.dart';

part 'update_wiki_page_body.g.dart';

@JsonSerializable()
class UpdateWikiPageBody {
  const UpdateWikiPageBody({
    required this.wikiPage,
  });
  
  factory UpdateWikiPageBody.fromJson(Map<String, Object?> json) => _$UpdateWikiPageBodyFromJson(json);
  
  @JsonKey(name: 'wiki_page')
  final UpdateWikiPageBodyWikiPage wikiPage;

  Map<String, Object?> toJson() => _$UpdateWikiPageBodyToJson(this);
}
