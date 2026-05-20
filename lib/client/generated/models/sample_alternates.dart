// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'sample_alternates_original.dart';
import 'sample_alternates_samples.dart';
import 'sample_alternates_variants.dart';

part 'sample_alternates.g.dart';

/// Alternate versions of the sample for video posts
@JsonSerializable()
class SampleAlternates {
  const SampleAlternates({
    this.has,
    this.original,
    this.variants,
    this.samples,
  });
  
  factory SampleAlternates.fromJson(Map<String, Object?> json) => _$SampleAlternatesFromJson(json);
  
  /// Whether alternate versions exist
  final bool? has;
  final SampleAlternatesOriginal? original;
  final SampleAlternatesVariants? variants;
  final SampleAlternatesSamples? samples;

  Map<String, Object?> toJson() => _$SampleAlternatesToJson(this);
}
