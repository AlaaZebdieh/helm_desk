part of 'inbox_cubit.dart';

sealed class InboxState extends Equatable {
  const InboxState();

  @override
  List<Object?> get props => [];
}

final class InboxInitial extends InboxState {}

final class InboxLoading extends InboxState {}

final class InboxLoaded extends InboxState {
  final List<Ticket> tickets;
  final String? nextCursor;
  final int total;
  final String? statusFilter;
  final bool myTicketsOnly;
  final String query;
  final bool isLoadingMore;

  const InboxLoaded({
    required this.tickets,
    this.nextCursor,
    required this.total,
    this.statusFilter,
    this.myTicketsOnly = false,
    this.query = '',
    this.isLoadingMore = false,
  });

  InboxLoaded copyWith({
    List<Ticket>? tickets,
    String? nextCursor,
    int? total,
    String? statusFilter,
    bool? myTicketsOnly,
    String? query,
    bool? isLoadingMore,
  }) {
    return InboxLoaded(
      tickets: tickets ?? this.tickets,
      nextCursor: nextCursor ?? this.nextCursor,
      total: total ?? this.total,
      statusFilter: statusFilter ?? this.statusFilter,
      myTicketsOnly: myTicketsOnly ?? this.myTicketsOnly,
      query: query ?? this.query,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        tickets,
        nextCursor,
        total,
        statusFilter,
        myTicketsOnly,
        query,
        isLoadingMore,
      ];
}

final class InboxFailure extends InboxState {
  final Failure failure;

  const InboxFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}
