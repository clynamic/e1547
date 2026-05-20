// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'appeal_status.dart';
import 'ticket_qtype.dart';

part 'ticket.g.dart';

/// A ticket object representing a user complaint or moderation issue.
@JsonSerializable()
class Ticket {
  const Ticket({
    required this.id,
    required this.creatorId,
    required this.reason,
    required this.dispId,
    required this.qtype,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.response,
    required this.handlerId,
    this.claimantId,
    this.reportReason,
    this.accusedId,
  });
  
  factory Ticket.fromJson(Map<String, Object?> json) => _$TicketFromJson(json);
  
  /// The unique ID of the ticket
  final int id;

  /// The ID of the user who created the ticket
  @JsonKey(name: 'creator_id')
  final int creatorId;

  /// The reason for the ticket
  final String reason;

  /// The ID of the reported content associated with the ticket
  @JsonKey(name: 'disp_id')
  final int dispId;
  final TicketQtype qtype;
  final AppealStatus status;

  /// The time when the ticket was created
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// The last time the ticket was updated
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  /// The response to the ticket
  final String response;

  /// The ID of the user handling the ticket
  @JsonKey(name: 'handler_id')
  final int handlerId;

  /// The ID of the claimant user
  @JsonKey(name: 'claimant_id')
  final int? claimantId;

  /// The post report reason for the ticket
  @JsonKey(name: 'report_reason')
  final String? reportReason;

  /// The ID of the accused user
  @JsonKey(name: 'accused_id')
  final int? accusedId;

  Map<String, Object?> toJson() => _$TicketToJson(this);
}
