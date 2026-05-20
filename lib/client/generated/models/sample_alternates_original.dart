// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'sample_alternates_original.g.dart';

/// The original video version
@JsonSerializable()
class SampleAlternatesOriginal {
  const SampleAlternatesOriginal({
    this.codec,
    this.fps,
    this.size,
    this.width,
    this.height,
    this.url,
  });
  
  factory SampleAlternatesOriginal.fromJson(Map<String, Object?> json) => _$SampleAlternatesOriginalFromJson(json);
  
  final String? codec;
  final int? fps;
  final int? size;
  final int? width;
  final int? height;
  final String? url;

  Map<String, Object?> toJson() => _$SampleAlternatesOriginalToJson(this);
}
