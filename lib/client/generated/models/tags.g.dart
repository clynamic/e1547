// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tags.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tags _$TagsFromJson(Map<String, dynamic> json) => Tags(
  general: (json['general'] as List<dynamic>).map((e) => e as String).toList(),
  artist: (json['artist'] as List<dynamic>).map((e) => e as String).toList(),
  contributor: (json['contributor'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  copyright: (json['copyright'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  character: (json['character'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  species: (json['species'] as List<dynamic>).map((e) => e as String).toList(),
  invalid: (json['invalid'] as List<dynamic>).map((e) => e as String).toList(),
  meta: (json['meta'] as List<dynamic>).map((e) => e as String).toList(),
  lore: (json['lore'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$TagsToJson(Tags instance) => <String, dynamic>{
  'general': instance.general,
  'artist': instance.artist,
  'contributor': instance.contributor,
  'copyright': instance.copyright,
  'character': instance.character,
  'species': instance.species,
  'invalid': instance.invalid,
  'meta': instance.meta,
  'lore': instance.lore,
};
