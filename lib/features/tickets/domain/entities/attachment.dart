import 'package:equatable/equatable.dart';

class Attachment extends Equatable {
  final String id;
  final String filename;
  final String contentType;
  final int size;

  const Attachment({
    required this.id,
    required this.filename,
    required this.contentType,
    required this.size,
  });

  @override
  List<Object?> get props => [id, filename, contentType, size];
}
