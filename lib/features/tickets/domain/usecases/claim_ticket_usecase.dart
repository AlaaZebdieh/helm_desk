import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ticket.dart';
import '../repositories/tickets_repository.dart';

class ClaimTicketParams extends Equatable {
  final String id;

  const ClaimTicketParams(this.id);

  @override
  List<Object?> get props => [id];
}

class ClaimTicketUsecase implements Usecase<Ticket, ClaimTicketParams> {
  final TicketsRepository repository;

  ClaimTicketUsecase({required this.repository});

  @override
  Future<Either<Failure, Ticket>> call(ClaimTicketParams params) {
    return repository.claimTicket(params.id);
  }
}
