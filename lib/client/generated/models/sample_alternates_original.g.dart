// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_alternates_original.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SampleAlternatesOriginal _$SampleAlternatesOriginalFromJson(
  Map<String, dynamic> json,
) => SampleAlternatesOriginal(
  codec: json['codec'] as String?,
  fps: (json['fps'] as num?)?.toInt(),
  size: (json['size'] as num?)?.toInt(),
  width: (json['width'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
  url: json['url'] as String?,
);

Map<String, dynamic> _$SampleAlternatesOriginalToJson(
  SampleAlternatesOriginal instance,
) => <String, dynamic>{
  'codec': instance.codec,
  'fps': instance.fps,
  'size': instance.size,
  'width': instance.width,
  'height': instance.height,
  'url': instance.url,
};
