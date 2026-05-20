// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_alternates_samples.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SampleAlternatesSamples _$SampleAlternatesSamplesFromJson(
  Map<String, dynamic> json,
) => SampleAlternatesSamples(
  url: json['url'] as String?,
  width: (json['width'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
);

Map<String, dynamic> _$SampleAlternatesSamplesToJson(
  SampleAlternatesSamples instance,
) => <String, dynamic>{
  'url': instance.url,
  'width': instance.width,
  'height': instance.height,
};
