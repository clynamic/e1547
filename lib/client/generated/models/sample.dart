// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'sample_alternates.dart';

part 'sample.g.dart';

@JsonSerializable()
class Sample {
  const Sample({
    required this.has,
    required this.height,
    required this.width,
    required this.url,
    this.alt,
    this.alternates,
  });
  
  factory Sample.fromJson(Map<String, Object?> json) => _$SampleFromJson(json);
  
  /// Whether the sample exists
  final bool has;

  /// The height of the sample image in pixels
  final int height;

  /// The width of the sample image in pixels
  final int width;

  /// The URL of the sample image
  final String url;

  /// The URL of the WebP sample image
  final String? alt;
  final SampleAlternates? alternates;

  Map<String, Object?> toJson() => _$SampleToJson(this);
}
