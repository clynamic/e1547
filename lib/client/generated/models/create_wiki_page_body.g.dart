// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_wiki_page_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateWikiPageBody _$CreateWikiPageBodyFromJson(Map<String, dynamic> json) =>
    CreateWikiPageBody(
      wikiPage: CreateWikiPageBodyWikiPage.fromJson(
        json['wiki_page'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CreateWikiPageBodyToJson(CreateWikiPageBody instance) =>
    <String, dynamic>{'wiki_page': instance.wikiPage};
