// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'file_ext.dart';

part 'file.g.dart';

@JsonSerializable()
class File {
  const File({
    required this.width,
    required this.height,
    required this.ext,
    required this.size,
    required this.md5,
    required this.url,
  });
  
  factory File.fromJson(Map<String, Object?> json) => _$FileFromJson(json);
  
  /// The width of the file in pixels
  final int width;

  /// The height of the file in pixels
  final int height;
  final FileExt ext;

  /// The size of the file in bytes
  final int size;

  /// The MD5 hash of the file
  final String md5;

  /// The URL of the file
  final String url;

  Map<String, Object?> toJson() => _$FileToJson(this);
}
