import 'package:equatable/equatable.dart';

import '../../domain/entities/attachment.dart';

class AttachmentModel extends Equatable {
  final String id;
  final String filename;
  final String contentType;
  final int size;

  const AttachmentModel({
    required this.id,
    required this.filename,
    required this.contentType,
    required this.size,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'] as String,
      filename: json['filename'] as String,
      contentType: json['contentType'] as String,
      size: json['size'] as int,
    );
  }

  Attachment toEntity() => Attachment(
        id: id,
        filename: filename,
        contentType: contentType,
        size: size,
      );

  @override
  List<Object?> get props => [id, filename, contentType, size];
}
