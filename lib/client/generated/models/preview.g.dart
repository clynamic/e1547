// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preview _$PreviewFromJson(Map<String, dynamic> json) => Preview(
  width: (json['width'] as num).toInt(),
  height: (json['height'] as num).toInt(),
  url: json['url'] as String,
  alt: json['alt'] as String?,
);

Map<String, dynamic> _$PreviewToJson(Preview instance) => <String, dynamic>{
  'width': instance.width,
  'height': instance.height,
  'url': instance.url,
  'alt': instance.alt,
};
