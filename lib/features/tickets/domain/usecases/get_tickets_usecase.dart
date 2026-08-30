import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/tickets_page.dart';
import '../repositories/tickets_repository.dart';

class GetTicketsParams extends Equatable {
  final String? status;
  final String? assignee;
  final String? query;
  final String? cursor;
  final int limit;

  const GetTicketsParams({
    this.status,
    this.assignee,
    this.query,
    this.cursor,
    this.limit = 25,
  });

  @override
  List<Object?> get props => [status, assignee, query, cursor, limit];
}

class GetTicketsUsecase implements Usecase<TicketsPage, GetTicketsParams> {
  final TicketsRepository repository;

  GetTicketsUsecase({required this.repository});

  @override
  Future<Either<Failure, TicketsPage>> call(GetTicketsParams params) {
    return repository.getTickets(
      status: params.status,
      assignee: params.assignee,
      query: params.query,
      cursor: params.cursor,
      limit: params.limit,
    );
  }
}
