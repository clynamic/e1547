// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'sample_alternates_samples.g.dart';

@JsonSerializable()
class SampleAlternatesSamples {
  const SampleAlternatesSamples({
    this.url,
    this.width,
    this.height,
  });
  
  factory SampleAlternatesSamples.fromJson(Map<String, Object?> json) => _$SampleAlternatesSamplesFromJson(json);
  
  final String? url;
  final int? width;
  final int? height;

  Map<String, Object?> toJson() => _$SampleAlternatesSamplesToJson(this);
}
