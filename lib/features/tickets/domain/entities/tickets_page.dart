import 'package:equatable/equatable.dart';

import 'ticket.dart';

class TicketsPage extends Equatable {
  final List<Ticket> items;
  final String? nextCursor;
  final int total;

  const TicketsPage({
    required this.items,
    this.nextCursor,
    required this.total,
  });

  @override
  List<Object?> get props => [items, nextCursor, total];
}
