// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/get_appeals_search_status.dart';
import '../models/ticket.dart';
import '../models/ticket_qtype.dart';
import '../models/update_ticket_body.dart';

part 'tickets_client.g.dart';

@RestApi()
abstract class TicketsClient {
  factory TicketsClient(Dio dio, {String? baseUrl}) = _TicketsClient;

  /// Get a list of tickets.
  ///
  /// Returns a list of tickets based on search criteria.
  ///
  /// [page] - The page number to retrieve.
  ///
  /// [limit] - The number of tickets to retrieve per page.
  ///
  /// [searchCreatedAt] - Filter by the creation date of the ticket.
  ///
  /// [searchUpdatedAt] - Filter by the last update date of the ticket.
  ///
  /// [searchId] - Filter by ticket ID.
  ///
  /// [searchCreatorName] - Filter by the creator's username.
  ///
  /// [searchAccusedName] - Filter by the accused user's username.
  ///
  /// [searchClaimantName] - Filter by the claimant's username.
  ///
  /// [searchReason] - Filter by the reason for the ticket.
  ///
  /// [searchQtype] - Filter by the type of the ticket (e.g., user, comment, post).
  ///
  /// [searchStatus] - Filter by the status of the ticket.
  ///
  /// [searchDispId] - Filter by the reported content ID.
  @GET('/tickets.json')
  Future<List<Ticket>> getTickets({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search[created_at]') String? searchCreatedAt,
    @Query('search[updated_at]') String? searchUpdatedAt,
    @Query('search[id]') String? searchId,
    @Query('search[creator_name]') String? searchCreatorName,
    @Query('search[accused_name]') String? searchAccusedName,
    @Query('search[claimant_name]') String? searchClaimantName,
    @Query('search[reason]') String? searchReason,
    @Query('search[qtype]') TicketQtype? searchQtype,
    @Query('search[status]') GetAppealsSearchStatus? searchStatus,
    @Query('search[disp_id]') int? searchDispId,
  });

  /// Get a ticket by ID.
  ///
  /// Returns detailed information about a specific ticket identified by its ID.
  ///
  /// [id] - The unique ID of the ticket to retrieve.
  @GET('/tickets/{id}.json')
  Future<Ticket> getTicket({
    @Path('id') required int id,
  });

  /// Update a ticket.
  ///
  /// Updates a ticket's status and response. Automatically claims the ticket for the current user.
  ///
  /// [id] - The unique ID of the ticket.
  @PUT('/tickets/{id}.json')
  Future<Ticket> updateTicket({
    @Path('id') required int id,
    @Body() required UpdateTicketBody body,
  });

  /// Claim a ticket.
  ///
  /// Claims a pending ticket to indicate you are handling it.
  ///
  /// [id] - The unique ID of the ticket.
  @POST('/tickets/{id}/claim.json')
  Future<Ticket> claimTicket({
    @Path('id') required int id,
  });

  /// Unclaim a ticket.
  ///
  /// Releases your claim on a ticket so others can handle it.
  ///
  /// [id] - The unique ID of the ticket.
  @POST('/tickets/{id}/unclaim.json')
  Future<Ticket> unclaimTicket({
    @Path('id') required int id,
  });
}
