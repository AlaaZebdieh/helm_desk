import 'package:equatable/equatable.dart';

class ReplyAttachment extends Equatable {
  final String id;
  final String filename;

  const ReplyAttachment({
    required this.id,
    required this.filename,
  });

  bool get isImage {
    final lower = filename.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg');
  }

  @override
  List<Object?> get props => [id, filename];
}
