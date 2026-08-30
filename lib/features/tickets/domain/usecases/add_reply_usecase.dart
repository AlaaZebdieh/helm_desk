import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/reply.dart';
import '../repositories/tickets_repository.dart';

class AddReplyParams extends Equatable {
  final String ticketId;
  final String body;

  const AddReplyParams({required this.ticketId, required this.body});

  @override
  List<Object?> get props => [ticketId, body];
}

class AddReplyUsecase implements Usecase<Reply, AddReplyParams> {
  final TicketsRepository repository;

  AddReplyUsecase({required this.repository});

  @override
  Future<Either<Failure, Reply>> call(AddReplyParams params) {
    return repository.addReply(id: params.ticketId, body: params.body);
  }
}
