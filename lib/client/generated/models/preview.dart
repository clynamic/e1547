// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'preview.g.dart';

@JsonSerializable()
class Preview {
  const Preview({
    required this.width,
    required this.height,
    required this.url,
    this.alt,
  });
  
  factory Preview.fromJson(Map<String, Object?> json) => _$PreviewFromJson(json);
  
  /// The width of the preview in pixels
  final int width;

  /// The height of the preview in pixels
  final int height;

  /// The URL of the preview image
  final String url;

  /// The URL of the WebP preview image
  final String? alt;

  Map<String, Object?> toJson() => _$PreviewToJson(this);
}
