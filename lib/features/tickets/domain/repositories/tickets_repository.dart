import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures/failures.dart';
import '../entities/attachment.dart';
import '../entities/reply.dart';
import '../entities/ticket.dart';
import '../entities/tickets_page.dart';

abstract class TicketsRepository {
  Future<Either<Failure, TicketsPage>> getTickets({
    String? status,
    String? assignee,
    String? query,
    String? cursor,
    int limit,
  });

  Future<Either<Failure, ({Ticket ticket, String? etag})>> getTicket(String id);

  Future<Either<Failure, Ticket>> updateTicket({
    required String id,
    required int version,
    String? status,
    String? priority,
  });

  Future<Either<Failure, Ticket>> claimTicket(String id);

  Future<Either<Failure, Reply>> addReply({
    required String id,
    required String body,
  });

  Future<Either<Failure, Attachment>> uploadAttachment({
    required String filename,
    required String contentType,
    required String base64Data,
  });
}
