import '../../../../core/errors/exceptions/server_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_error_utils.dart';
import '../models/attachment_model.dart';
import '../models/reply_model.dart';
import '../models/ticket_model.dart';
import '../network/tickets_endpoints.dart';

typedef TicketDetailResult = ({TicketModel ticket, String? etag});

abstract class TicketsRemoteDataSource {
  Future<({List<TicketModel> items, String? nextCursor, int total})> getTickets({
    String? status,
    String? assignee,
    String? query,
    String? cursor,
    int limit,
  });

  Future<TicketDetailResult> getTicket(String id);

  Future<TicketModel> updateTicket({
    required String id,
    required int version,
    String? status,
    String? priority,
  });

  Future<TicketModel> claimTicket(String id);

  Future<ReplyModel> addReply({required String id, required String body});

  Future<AttachmentModel> uploadAttachment({
    required String filename,
    required String contentType,
    required String base64Data,
  });
}

class TicketsRemoteDataSourceImpl implements TicketsRemoteDataSource {
  final ApiClient apiClient;

  TicketsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<({List<TicketModel> items, String? nextCursor, int total})> getTickets({
    String? status,
    String? assignee,
    String? query,
    String? cursor,
    int limit = 25,
  }) async {
    final params = <String, dynamic>{'limit': limit};
    if (status != null && status.isNotEmpty) params['status'] = status;
    if (assignee != null && assignee.isNotEmpty) params['assignee'] = assignee;
    if (query != null && query.isNotEmpty) params['q'] = query;
    if (cursor != null && cursor.isNotEmpty) params['cursor'] = cursor;

    final response = await apiClient.get(
      TicketsEndpoints.tickets,
      queryParameters: params,
    );

    final json = response.data as Map<String, dynamic>;
    final items = (json['items'] as List<dynamic>)
        .map((e) => TicketModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return (
      items: items,
      nextCursor: json['nextCursor'] as String?,
      total: json['total'] as int,
    );
  }

  @override
  Future<TicketDetailResult> getTicket(String id) async {
    final response = await apiClient.get(TicketsEndpoints.ticket(id));
    final ticket = TicketModel.fromJson(response.data as Map<String, dynamic>);
    return (ticket: ticket, etag: response.header('etag'));
  }

  @override
  Future<TicketModel> updateTicket({
    required String id,
    required int version,
    String? status,
    String? priority,
  }) async {
    final body = <String, dynamic>{};
    if (status != null) body['status'] = status;
    if (priority != null) body['priority'] = priority;

    try {
      final response = await apiClient.patch(
        TicketsEndpoints.ticket(id),
        body: body,
        headers: {'If-Match': '"$version"'},
      );
      return TicketModel.fromJson(response.data as Map<String, dynamic>);
    } on ServerException catch (e) {
      throw _enrichConflict(e);
    }
  }

  @override
  Future<TicketModel> claimTicket(String id) async {
    try {
      final response = await apiClient.post(TicketsEndpoints.claim(id));
      return TicketModel.fromJson(response.data as Map<String, dynamic>);
    } on ServerException catch (e) {
      throw _enrichConflict(e);
    }
  }

  @override
  Future<ReplyModel> addReply({required String id, required String body}) async {
    final response = await apiClient.post(
      TicketsEndpoints.replies(id),
      body: {'body': body},
    );
    return ReplyModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AttachmentModel> uploadAttachment({
    required String filename,
    required String contentType,
    required String base64Data,
  }) async {
    final response = await apiClient.post(
      TicketsEndpoints.attachments,
      body: {
        'filename': filename,
        'contentType': contentType,
        'data': base64Data,
      },
    );
    return AttachmentModel.fromJson(response.data as Map<String, dynamic>);
  }

  ServerException _enrichConflict(ServerException e) {
    if (e.code != 409 || e.data is! Map) return e;
    final data = e.data as Map<String, dynamic>;
    final ticketJson = data['ticket'];
    if (ticketJson is Map<String, dynamic>) {
      return ServerException(
        e.code,
        parseApiErrorMessage(data) ?? e.msg,
        {
          'code': parseApiErrorCode(data),
          'ticket': TicketModel.fromJson(ticketJson).toEntity(),
        },
      );
    }
    return e;
  }
}
