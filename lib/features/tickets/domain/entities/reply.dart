import 'package:equatable/equatable.dart';

class Reply extends Equatable {
  final String id;
  final String? authorId;
  final String authorName;
  final String body;
  final DateTime createdAt;

  const Reply({
    required this.id,
    this.authorId,
    required this.authorName,
    required this.body,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, authorId, authorName, body, createdAt];
}
