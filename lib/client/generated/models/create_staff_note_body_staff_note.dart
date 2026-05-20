// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_staff_note_body_staff_note.g.dart';

@JsonSerializable()
class CreateStaffNoteBodyStaffNote {
  const CreateStaffNoteBodyStaffNote({
    required this.body,
  });
  
  factory CreateStaffNoteBodyStaffNote.fromJson(Map<String, Object?> json) => _$CreateStaffNoteBodyStaffNoteFromJson(json);
  
  /// The body text of the staff note
  final String body;

  Map<String, Object?> toJson() => _$CreateStaffNoteBodyStaffNoteToJson(this);
}
