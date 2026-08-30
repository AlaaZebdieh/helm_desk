import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ticket.dart';
import '../repositories/tickets_repository.dart';

class UpdateTicketParams extends Equatable {
  final String id;
  final int version;
  final String? status;
  final String? priority;

  const UpdateTicketParams({
    required this.id,
    required this.version,
    this.status,
    this.priority,
  });

  @override
  List<Object?> get props => [id, version, status, priority];
}

class UpdateTicketUsecase implements Usecase<Ticket, UpdateTicketParams> {
  final TicketsRepository repository;

  UpdateTicketUsecase({required this.repository});

  @override
  Future<Either<Failure, Ticket>> call(UpdateTicketParams params) {
    return repository.updateTicket(
      id: params.id,
      version: params.version,
      status: params.status,
      priority: params.priority,
    );
  }
}
