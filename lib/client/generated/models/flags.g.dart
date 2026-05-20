// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flags.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Flags _$FlagsFromJson(Map<String, dynamic> json) => Flags(
  pending: json['pending'] as bool,
  flagged: json['flagged'] as bool,
  noteLocked: json['note_locked'] as bool,
  statusLocked: json['status_locked'] as bool,
  ratingLocked: json['rating_locked'] as bool,
  deleted: json['deleted'] as bool,
);

Map<String, dynamic> _$FlagsToJson(Flags instance) => <String, dynamic>{
  'pending': instance.pending,
  'flagged': instance.flagged,
  'note_locked': instance.noteLocked,
  'status_locked': instance.statusLocked,
  'rating_locked': instance.ratingLocked,
  'deleted': instance.deleted,
};
