// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_alternates_variants.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SampleAlternatesVariants _$SampleAlternatesVariantsFromJson(
  Map<String, dynamic> json,
) => SampleAlternatesVariants(
  codec: json['codec'] as String?,
  url: json['url'] as String?,
  width: (json['width'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
);

Map<String, dynamic> _$SampleAlternatesVariantsToJson(
  SampleAlternatesVariants instance,
) => <String, dynamic>{
  'codec': instance.codec,
  'url': instance.url,
  'width': instance.width,
  'height': instance.height,
};
