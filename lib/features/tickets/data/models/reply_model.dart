import 'package:equatable/equatable.dart';

import '../../domain/entities/reply.dart';

class ReplyModel extends Equatable {
  final String id;
  final String? authorId;
  final String authorName;
  final String body;
  final String createdAt;

  const ReplyModel({
    required this.id,
    this.authorId,
    required this.authorName,
    required this.body,
    required this.createdAt,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    return ReplyModel(
      id: json['id'] as String,
      authorId: json['authorId'] as String?,
      authorName: json['authorName'] as String,
      body: json['body'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  Reply toEntity() => Reply(
        id: id,
        authorId: authorId,
        authorName: authorName,
        body: body,
        createdAt: DateTime.parse(createdAt),
      );

  @override
  List<Object?> get props => [id, authorId, authorName, body, createdAt];
}
