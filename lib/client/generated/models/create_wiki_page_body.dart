// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'create_wiki_page_body_wiki_page.dart';

part 'create_wiki_page_body.g.dart';

@JsonSerializable()
class CreateWikiPageBody {
  const CreateWikiPageBody({
    required this.wikiPage,
  });
  
  factory CreateWikiPageBody.fromJson(Map<String, Object?> json) => _$CreateWikiPageBodyFromJson(json);
  
  @JsonKey(name: 'wiki_page')
  final CreateWikiPageBodyWikiPage wikiPage;

  Map<String, Object?> toJson() => _$CreateWikiPageBodyToJson(this);
}
