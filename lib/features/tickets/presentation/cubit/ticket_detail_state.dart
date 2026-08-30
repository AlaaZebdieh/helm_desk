part of 'ticket_detail_cubit.dart';

sealed class TicketDetailState extends Equatable {
  const TicketDetailState();

  @override
  List<Object?> get props => [];
}

final class TicketDetailInitial extends TicketDetailState {}

final class TicketDetailLoading extends TicketDetailState {}

final class TicketDetailLoaded extends TicketDetailState {
  final Ticket ticket;
  final String? etag;
  final bool isSubmitting;
  final Ticket? conflictTicket;
  final String? conflictMessage;

  const TicketDetailLoaded({
    required this.ticket,
    this.etag,
    this.isSubmitting = false,
    this.conflictTicket,
    this.conflictMessage,
  });

  TicketDetailLoaded copyWith({
    Ticket? ticket,
    String? etag,
    bool? isSubmitting,
    Ticket? conflictTicket,
    String? conflictMessage,
    bool clearConflict = false,
  }) {
    return TicketDetailLoaded(
      ticket: ticket ?? this.ticket,
      etag: etag ?? this.etag,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      conflictTicket: clearConflict ? null : (conflictTicket ?? this.conflictTicket),
      conflictMessage: clearConflict ? null : (conflictMessage ?? this.conflictMessage),
    );
  }

  @override
  List<Object?> get props => [
        ticket,
        etag,
        isSubmitting,
        conflictTicket,
        conflictMessage,
      ];
}

final class TicketDetailFailure extends TicketDetailState {
  final Failure failure;

  const TicketDetailFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}
