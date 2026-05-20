// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

File _$FileFromJson(Map<String, dynamic> json) => File(
  width: (json['width'] as num).toInt(),
  height: (json['height'] as num).toInt(),
  ext: FileExt.fromJson(json['ext'] as String),
  size: (json['size'] as num).toInt(),
  md5: json['md5'] as String,
  url: json['url'] as String,
);

Map<String, dynamic> _$FileToJson(File instance) => <String, dynamic>{
  'width': instance.width,
  'height': instance.height,
  'ext': _$FileExtEnumMap[instance.ext]!,
  'size': instance.size,
  'md5': instance.md5,
  'url': instance.url,
};

const _$FileExtEnumMap = {
  FileExt.jpg: 'jpg',
  FileExt.png: 'png',
  FileExt.gif: 'gif',
  FileExt.webm: 'webm',
  FileExt.mp4: 'mp4',
  FileExt.swf: 'swf',
  FileExt.apng: 'apng',
  FileExt.$unknown: r'$unknown',
};
