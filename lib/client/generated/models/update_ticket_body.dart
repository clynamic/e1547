// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'appeal_status.dart';

part 'update_ticket_body.g.dart';

@JsonSerializable()
class UpdateTicketBody {
  const UpdateTicketBody({
    this.object122,
    this.object123,
    this.object124,
    this.object125,
    this.forceClaim,
  });
  
  factory UpdateTicketBody.fromJson(Map<String, Object?> json) => _$UpdateTicketBodyFromJson(json);
  
  /// The response to the ticket.
  /// Incorrect name has been replaced. Original name: `ticket[response]`.
  @JsonKey(name: 'ticket[response]')
  final String? object122;

  /// Incorrect name has been replaced. Original name: `ticket[status]`.
  @JsonKey(name: 'ticket[status]')
  final AppealStatus? object123;

  /// The type of record to apply if the ticket content is warnable.
  /// Incorrect name has been replaced. Original name: `ticket[record_type]`.
  @JsonKey(name: 'ticket[record_type]')
  final String? object124;

  /// Whether to send a DMail notification about the update.
  /// Incorrect name has been replaced. Original name: `ticket[send_update_dmail]`.
  @JsonKey(name: 'ticket[send_update_dmail]')
  final bool? object125;

  /// Force claiming the ticket even if already claimed by another user
  @JsonKey(name: 'force_claim')
  final bool? forceClaim;

  Map<String, Object?> toJson() => _$UpdateTicketBodyToJson(this);
}
