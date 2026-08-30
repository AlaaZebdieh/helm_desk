import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ticket.dart';
import '../repositories/tickets_repository.dart';

class GetTicketParams extends Equatable {
  final String id;

  const GetTicketParams(this.id);

  @override
  List<Object?> get props => [id];
}

class GetTicketUsecase
    implements Usecase<({Ticket ticket, String? etag}), GetTicketParams> {
  final TicketsRepository repository;

  GetTicketUsecase({required this.repository});

  @override
  Future<Either<Failure, ({Ticket ticket, String? etag})>> call(
    GetTicketParams params,
  ) {
    return repository.getTicket(params.id);
  }
}
