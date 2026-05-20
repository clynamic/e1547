// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Score _$ScoreFromJson(Map<String, dynamic> json) => Score(
  up: (json['up'] as num).toInt(),
  down: (json['down'] as num).toInt(),
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$ScoreToJson(Score instance) => <String, dynamic>{
  'up': instance.up,
  'down': instance.down,
  'total': instance.total,
};
