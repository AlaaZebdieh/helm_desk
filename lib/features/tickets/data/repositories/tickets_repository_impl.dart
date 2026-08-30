import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures/failures.dart';
import '../../../../core/utils/safe_api_call.dart';
import '../../domain/entities/attachment.dart';
import '../../domain/entities/reply.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/entities/tickets_page.dart';
import '../../domain/repositories/tickets_repository.dart';
import '../datasources/tickets_remote_data_source.dart';

class TicketsRepositoryImpl implements TicketsRepository {
  final TicketsRemoteDataSource remoteDataSource;

  TicketsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, TicketsPage>> getTickets({
    String? status,
    String? assignee,
    String? query,
    String? cursor,
    int limit = 25,
  }) async {
    return safeApiCall(() async {
      final result = await remoteDataSource.getTickets(
        status: status,
        assignee: assignee,
        query: query,
        cursor: cursor,
        limit: limit,
      );
      return TicketsPage(
        items: result.items.map((e) => e.toEntity()).toList(),
        nextCursor: result.nextCursor,
        total: result.total,
      );
    });
  }

  @override
  Future<Either<Failure, ({Ticket ticket, String? etag})>> getTicket(
    String id,
  ) async {
    return safeApiCall(() async {
      final result = await remoteDataSource.getTicket(id);
      return (ticket: result.ticket.toEntity(), etag: result.etag);
    });
  }

  @override
  Future<Either<Failure, Ticket>> updateTicket({
    required String id,
    required int version,
    String? status,
    String? priority,
  }) async {
    return safeApiCall(() async {
      final ticket = await remoteDataSource.updateTicket(
        id: id,
        version: version,
        status: status,
        priority: priority,
      );
      return ticket.toEntity();
    });
  }

  @override
  Future<Either<Failure, Ticket>> claimTicket(String id) async {
    return safeApiCall(() async {
      final ticket = await remoteDataSource.claimTicket(id);
      return ticket.toEntity();
    });
  }

  @override
  Future<Either<Failure, Reply>> addReply({
    required String id,
    required String body,
  }) async {
    return safeApiCall(() async {
      final reply = await remoteDataSource.addReply(id: id, body: body);
      return reply.toEntity();
    });
  }

  @override
  Future<Either<Failure, Attachment>> uploadAttachment({
    required String filename,
    required String contentType,
    required String base64Data,
  }) async {
    return safeApiCall(() async {
      final attachment = await remoteDataSource.uploadAttachment(
        filename: filename,
        contentType: contentType,
        base64Data: base64Data,
      );
      return attachment.toEntity();
    });
  }
}
