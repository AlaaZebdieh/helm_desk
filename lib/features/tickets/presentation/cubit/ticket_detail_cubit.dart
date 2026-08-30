import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures/failures.dart';
import '../../../../core/errors/failures/server_failure.dart';
import '../../../../core/services/attachment_cache_service.dart';
import '../../../../core/services/sse_service.dart';
import '../../../../core/usecases/execute_usecase.dart';
import '../../domain/entities/attachment.dart';
import '../../domain/entities/reply.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/usecases/add_reply_usecase.dart';
import '../../domain/usecases/claim_ticket_usecase.dart';
import '../../domain/usecases/get_ticket_usecase.dart';
import '../../domain/usecases/update_ticket_usecase.dart';
import '../../domain/usecases/upload_attachment_usecase.dart';

part 'ticket_detail_state.dart';

class TicketDetailCubit extends Cubit<TicketDetailState>
    with UsecaseExecutor<TicketDetailState> {
  final GetTicketUsecase getTicketUsecase;
  final UpdateTicketUsecase updateTicketUsecase;
  final ClaimTicketUsecase claimTicketUsecase;
  final AddReplyUsecase addReplyUsecase;
  final UploadAttachmentUsecase uploadAttachmentUsecase;
  final AttachmentCacheService attachmentCacheService;
  final SseService sseService;

  final String ticketId;
  StreamSubscription<SseEvent>? _sseSub;

  TicketDetailCubit({
    required this.ticketId,
    required this.getTicketUsecase,
    required this.updateTicketUsecase,
    required this.claimTicketUsecase,
    required this.addReplyUsecase,
    required this.uploadAttachmentUsecase,
    required this.attachmentCacheService,
    required this.sseService,
  }) : super(TicketDetailInitial());

  void init() {
    sseService.start();
    _listenToSse();
    loadTicket();
  }

  void _listenToSse() {
    _sseSub?.cancel();
    _sseSub = sseService.stream.listen((event) {
      final current = state;
      if (current is! TicketDetailLoaded) return;

      if (event.type == 'ticket.updated' && event.data is Ticket) {
        final updated = event.data as Ticket;
        if (updated.id == ticketId) {
          emit(current.copyWith(
            ticket: current.ticket.copyWith(
              status: updated.status,
              priority: updated.priority,
              assigneeId: updated.assigneeId,
              version: updated.version,
              updatedAt: updated.updatedAt,
            ),
            etag: '"${updated.version}"',
          ));
        }
      } else if (event.type == 'ticket.reply' && event.data is Map) {
        final data = event.data as Map;
        if (data['ticketId'] == ticketId && data['reply'] is Reply) {
          final reply = data['reply'] as Reply;
          if (current.ticket.replies.any((r) => r.id == reply.id)) return;
          emit(current.copyWith(
            ticket: current.ticket.copyWith(
              replies: [...current.ticket.replies, reply],
            ),
          ));
        }
      }
    });
  }

  Future<void> loadTicket() async {
    await executeUsecase(
      () => getTicketUsecase(GetTicketParams(ticketId)),
      onLoading: () => emit(TicketDetailLoading()),
      onSuccess: (result) => emit(TicketDetailLoaded(
        ticket: result.ticket,
        etag: result.etag,
      )),
      onFailure: (failure) => emit(TicketDetailFailure(failure)),
    );
  }

  Future<void> updateStatus(String status) async {
    final current = state;
    if (current is! TicketDetailLoaded) return;

    emit(current.copyWith(isSubmitting: true, clearConflict: true));

    final result = await updateTicketUsecase(UpdateTicketParams(
      id: ticketId,
      version: current.ticket.version,
      status: status,
    ));

    result.fold(
      (failure) => _handleActionFailure(current, failure),
      (ticket) => emit(TicketDetailLoaded(
        ticket: current.ticket.copyWith(
          status: ticket.status,
          priority: ticket.priority,
          version: ticket.version,
          updatedAt: ticket.updatedAt,
        ),
        etag: '"${ticket.version}"',
      )),
    );
  }

  Future<void> updatePriority(String priority) async {
    final current = state;
    if (current is! TicketDetailLoaded) return;

    emit(current.copyWith(isSubmitting: true, clearConflict: true));

    final result = await updateTicketUsecase(UpdateTicketParams(
      id: ticketId,
      version: current.ticket.version,
      priority: priority,
    ));

    result.fold(
      (failure) => _handleActionFailure(current, failure),
      (ticket) => emit(TicketDetailLoaded(
        ticket: current.ticket.copyWith(
          status: ticket.status,
          priority: ticket.priority,
          version: ticket.version,
          updatedAt: ticket.updatedAt,
        ),
        etag: '"${ticket.version}"',
      )),
    );
  }

  Future<void> claim() async {
    final current = state;
    if (current is! TicketDetailLoaded) return;

    emit(current.copyWith(isSubmitting: true, clearConflict: true));

    final result = await claimTicketUsecase(ClaimTicketParams(ticketId));

    result.fold(
      (failure) => _handleActionFailure(current, failure),
      (ticket) => emit(TicketDetailLoaded(
        ticket: current.ticket.copyWith(
          assigneeId: ticket.assigneeId,
          version: ticket.version,
          updatedAt: ticket.updatedAt,
        ),
        etag: '"${ticket.version}"',
      )),
    );
  }

  Future<void> sendReply(String body, {File? attachment}) async {
    final current = state;
    if (current is! TicketDetailLoaded) return;
    if (body.trim().isEmpty && attachment == null) return;

    emit(current.copyWith(isSubmitting: true, clearConflict: true));

    var finalBody = body.trim();
    if (attachment != null) {
      final bytes = await attachment.readAsBytes();
      final base64Data = base64Encode(bytes);
      final filename = attachment.path.split('/').last;
      final contentType = _mimeType(filename);

      final uploadResult = await uploadAttachmentUsecase(UploadAttachmentParams(
        filename: filename,
        contentType: contentType,
        base64Data: base64Data,
      ));

      String? attachmentLine;
      Attachment? uploadedAttachment;
      uploadResult.fold(
        (failure) => emit(TicketDetailFailure(failure)),
        (attachmentEntity) {
          uploadedAttachment = attachmentEntity;
          attachmentLine = finalBody.isEmpty
              ? '[مرفق: ${attachmentEntity.filename} (${attachmentEntity.id})]'
              : '$finalBody\n[مرفق: ${attachmentEntity.filename} (${attachmentEntity.id})]';
        },
      );
      if (uploadedAttachment != null) {
        await attachmentCacheService.save(uploadedAttachment!.id, attachment);
      }
      if (attachmentLine == null) return;
      finalBody = attachmentLine!;
    }

    final result = await addReplyUsecase(AddReplyParams(
      ticketId: ticketId,
      body: finalBody,
    ));

    result.fold(
      (failure) => emit(TicketDetailFailure(failure)),
      (reply) => emit(TicketDetailLoaded(
        ticket: current.ticket.copyWith(
          replies: [...current.ticket.replies, reply],
          version: current.ticket.version + 1,
        ),
        etag: current.etag,
      )),
    );
  }

  void applyConflictTicket() {
    final current = state;
    if (current is! TicketDetailLoaded || current.conflictTicket == null) return;

    final conflict = current.conflictTicket!;
    emit(TicketDetailLoaded(
      ticket: conflict.copyWith(replies: current.ticket.replies),
      etag: '"${conflict.version}"',
    ));
  }

  void _handleActionFailure(TicketDetailLoaded current, Failure failure) {
    final conflict = _extractConflictTicket(failure);
    if (conflict != null) {
      emit(current.copyWith(
        isSubmitting: false,
        conflictTicket: conflict,
        conflictMessage: failure.msg,
      ));
      return;
    }
    emit(TicketDetailFailure(failure));
  }

  Ticket? _extractConflictTicket(Failure failure) {
    if (failure is! ServerFailure || failure.code != 409) return null;
    final data = failure.data;
    if (data is Map && data['ticket'] is Ticket) {
      return data['ticket'] as Ticket;
    }
    return null;
  }

  String _mimeType(String filename) {
    final lower = filename.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
    if (lower.endsWith('.pdf')) return 'application/pdf';
    if (lower.endsWith('.txt')) return 'text/plain';
    return 'application/octet-stream';
  }

  @override
  Future<void> close() {
    _sseSub?.cancel();
    return super.close();
  }
}
