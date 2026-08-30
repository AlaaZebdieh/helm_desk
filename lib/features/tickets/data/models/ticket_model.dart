import 'package:equatable/equatable.dart';

import '../../domain/entities/ticket.dart';
import 'reply_model.dart';

class TicketModel extends Equatable {
  final String id;
  final String subject;
  final String customer;
  final String status;
  final String priority;
  final String? assigneeId;
  final int version;
  final String createdAt;
  final String updatedAt;
  final List<ReplyModel> replies;

  const TicketModel({
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

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    final repliesJson = json['replies'] as List<dynamic>? ?? [];
    return TicketModel(
      id: json['id'] as String,
      subject: json['subject'] as String,
      customer: json['customer'] as String,
      status: json['status'] as String,
      priority: json['priority'] as String,
      assigneeId: json['assigneeId'] as String?,
      version: json['version'] as int,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      replies: repliesJson
          .map((e) => ReplyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Ticket toEntity() => Ticket(
        id: id,
        subject: subject,
        customer: customer,
        status: status,
        priority: priority,
        assigneeId: assigneeId,
        version: version,
        createdAt: DateTime.parse(createdAt),
        updatedAt: DateTime.parse(updatedAt),
        replies: replies.map((r) => r.toEntity()).toList(),
      );

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
