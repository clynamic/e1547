// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'tags.g.dart';

@JsonSerializable()
class Tags {
  const Tags({
    required this.general,
    required this.artist,
    required this.contributor,
    required this.copyright,
    required this.character,
    required this.species,
    required this.invalid,
    required this.meta,
    required this.lore,
  });
  
  factory Tags.fromJson(Map<String, Object?> json) => _$TagsFromJson(json);
  
  /// An array of general tags
  final List<String> general;

  /// An array of artist tags
  final List<String> artist;

  /// An array of contributor tags
  final List<String> contributor;

  /// An array of copyright tags
  final List<String> copyright;

  /// An array of character tags
  final List<String> character;

  /// An array of species tags
  final List<String> species;

  /// An array of invalid tags
  final List<String> invalid;

  /// An array of meta tags
  final List<String> meta;

  /// An array of lore tags
  final List<String> lore;

  Map<String, Object?> toJson() => _$TagsToJson(this);
}
