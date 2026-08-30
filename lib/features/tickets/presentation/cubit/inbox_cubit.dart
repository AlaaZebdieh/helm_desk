import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures/failures.dart';
import '../../../../core/services/sse_service.dart';
import '../../../../core/usecases/execute_usecase.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/usecases/get_tickets_usecase.dart';

part 'inbox_state.dart';

class InboxCubit extends Cubit<InboxState> with UsecaseExecutor<InboxState> {
  final GetTicketsUsecase getTicketsUsecase;
  final SseService sseService;

  StreamSubscription<SseEvent>? _sseSub;
  Timer? _searchDebounce;

  InboxCubit({
    required this.getTicketsUsecase,
    required this.sseService,
  }) : super(InboxInitial());

  void init() {
    sseService.start();
    _listenToSse();
    loadTickets();
  }

  void _listenToSse() {
    _sseSub?.cancel();
    _sseSub = sseService.stream.listen((event) {
      if (event.type != 'ticket.updated') return;
      final current = state;
      if (current is! InboxLoaded) return;
      if (event.data is! Ticket) return;

      final updated = event.data as Ticket;
      final index = current.tickets.indexWhere((t) => t.id == updated.id);
      if (index == -1) {
        emit(current.copyWith(tickets: [updated, ...current.tickets]));
      } else {
        final list = List<Ticket>.from(current.tickets);
        list[index] = updated;
        emit(current.copyWith(tickets: list));
      }
    });
  }

  Future<void> loadTickets({bool refresh = false}) async {
    final current = state is InboxLoaded ? state as InboxLoaded : null;
    final statusFilter = current?.statusFilter;
    final myTicketsOnly = current?.myTicketsOnly ?? false;
    final query = current?.query ?? '';

    await executeUsecase(
      () => getTicketsUsecase(GetTicketsParams(
        status: statusFilter,
        assignee: myTicketsOnly ? 'me' : null,
        query: query.isEmpty ? null : query,
      )),
      onLoading: () => emit(InboxLoading()),
      onSuccess: (page) => emit(InboxLoaded(
        tickets: page.items,
        nextCursor: page.nextCursor,
        total: page.total,
        statusFilter: statusFilter,
        myTicketsOnly: myTicketsOnly,
        query: query,
      )),
      onFailure: (failure) => emit(InboxFailure(failure)),
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! InboxLoaded) return;
    if (current.nextCursor == null || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));

    final result = await getTicketsUsecase(GetTicketsParams(
      status: current.statusFilter,
      assignee: current.myTicketsOnly ? 'me' : null,
      query: current.query.isEmpty ? null : current.query,
      cursor: current.nextCursor,
    ));

    result.fold(
      (failure) => emit(InboxFailure(failure)),
      (page) => emit(current.copyWith(
        tickets: [...current.tickets, ...page.items],
        nextCursor: page.nextCursor,
        total: page.total,
        isLoadingMore: false,
      )),
    );
  }

  void setStatusFilter(String? status) {
    final current = state is InboxLoaded ? state as InboxLoaded : null;
    emit(InboxLoaded(
      tickets: current?.tickets ?? [],
      nextCursor: current?.nextCursor,
      total: current?.total ?? 0,
      statusFilter: status,
      myTicketsOnly: current?.myTicketsOnly ?? false,
      query: current?.query ?? '',
    ));
    loadTickets();
  }

  void toggleMyTickets(bool value) {
    final current = state is InboxLoaded ? state as InboxLoaded : null;
    emit(InboxLoaded(
      tickets: current?.tickets ?? [],
      nextCursor: current?.nextCursor,
      total: current?.total ?? 0,
      statusFilter: current?.statusFilter,
      myTicketsOnly: value,
      query: current?.query ?? '',
    ));
    loadTickets();
  }

  void search(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      final current = state is InboxLoaded ? state as InboxLoaded : null;
      emit(InboxLoaded(
        tickets: current?.tickets ?? [],
        nextCursor: current?.nextCursor,
        total: current?.total ?? 0,
        statusFilter: current?.statusFilter,
        myTicketsOnly: current?.myTicketsOnly ?? false,
        query: query,
      ));
      loadTickets();
    });
  }

  @override
  Future<void> close() {
    _sseSub?.cancel();
    _searchDebounce?.cancel();
    return super.close();
  }
}
