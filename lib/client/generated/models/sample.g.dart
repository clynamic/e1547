// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sample _$SampleFromJson(Map<String, dynamic> json) => Sample(
  has: json['has'] as bool,
  height: (json['height'] as num).toInt(),
  width: (json['width'] as num).toInt(),
  url: json['url'] as String,
  alt: json['alt'] as String?,
  alternates: json['alternates'] == null
      ? null
      : SampleAlternates.fromJson(json['alternates'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SampleToJson(Sample instance) => <String, dynamic>{
  'has': instance.has,
  'height': instance.height,
  'width': instance.width,
  'url': instance.url,
  'alt': instance.alt,
  'alternates': instance.alternates,
};
