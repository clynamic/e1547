// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_wiki_page_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateWikiPageBody _$UpdateWikiPageBodyFromJson(Map<String, dynamic> json) =>
    UpdateWikiPageBody(
      wikiPage: UpdateWikiPageBodyWikiPage.fromJson(
        json['wiki_page'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$UpdateWikiPageBodyToJson(UpdateWikiPageBody instance) =>
    <String, dynamic>{'wiki_page': instance.wikiPage};
