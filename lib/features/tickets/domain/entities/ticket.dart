import 'package:equatable/equatable.dart';

import 'reply.dart';

class Ticket extends Equatable {
  final String id;
  final String subject;
  final String customer;
  final String status;
  final String priority;
  final String? assigneeId;
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Reply> replies;

  const Ticket({
    required this.id,
    required this.subject,
    required this.customer,
    required this.status,
    required this.priority,
    this.assigneeId,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.replies = const [],
  });

  Ticket copyWith({
    String? status,
    String? priority,
    String? assigneeId,
    int? version,
    DateTime? updatedAt,
    List<Reply>? replies,
  }) {
    return Ticket(
      id: id,
      subject: subject,
      customer: customer,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      assigneeId: assigneeId ?? this.assigneeId,
      version: version ?? this.version,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      replies: replies ?? this.replies,
    );
  }

  @override
  List<Object?> get props => [
        id,
        subject,
        customer,
        status,
        priority,
        assigneeId,
        version,
        createdAt,
        updatedAt,
        replies,
      ];
}
