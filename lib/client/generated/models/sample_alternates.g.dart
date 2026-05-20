// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_alternates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SampleAlternates _$SampleAlternatesFromJson(Map<String, dynamic> json) =>
    SampleAlternates(
      has: json['has'] as bool?,
      original: json['original'] == null
          ? null
          : SampleAlternatesOriginal.fromJson(
              json['original'] as Map<String, dynamic>,
            ),
      variants: json['variants'] == null
          ? null
          : SampleAlternatesVariants.fromJson(
              json['variants'] as Map<String, dynamic>,
            ),
      samples: json['samples'] == null
          ? null
          : SampleAlternatesSamples.fromJson(
              json['samples'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$SampleAlternatesToJson(SampleAlternates instance) =>
    <String, dynamic>{
      'has': instance.has,
      'original': instance.original,
      'variants': instance.variants,
      'samples': instance.samples,
    };
