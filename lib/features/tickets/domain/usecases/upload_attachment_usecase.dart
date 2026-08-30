import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/attachment.dart';
import '../repositories/tickets_repository.dart';

class UploadAttachmentParams extends Equatable {
  final String filename;
  final String contentType;
  final String base64Data;

  const UploadAttachmentParams({
    required this.filename,
    required this.contentType,
    required this.base64Data,
  });

  @override
  List<Object?> get props => [filename, contentType, base64Data];
}

class UploadAttachmentUsecase
    implements Usecase<Attachment, UploadAttachmentParams> {
  final TicketsRepository repository;

  UploadAttachmentUsecase({required this.repository});

  @override
  Future<Either<Failure, Attachment>> call(UploadAttachmentParams params) {
    return repository.uploadAttachment(
      filename: params.filename,
      contentType: params.contentType,
      base64Data: params.base64Data,
    );
  }
}
