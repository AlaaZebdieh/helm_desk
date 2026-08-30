import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../app/config/app_settings.dart';
import '../../features/tickets/data/models/reply_model.dart';
import '../../features/tickets/data/models/ticket_model.dart';

class SseEvent {
  final String id;
  final String type;
  final dynamic data;

  const SseEvent({required this.id, required this.type, required this.data});
}

class SseService {
  final _controller = StreamController<SseEvent>.broadcast();
  Dio? _dio;
  CancelToken? _cancelToken;
  String _lastEventId = '0';
  bool _running = false;

  Stream<SseEvent> get stream => _controller.stream;
  String get lastEventId => _lastEventId;

  void attach(Dio dio) => _dio = dio;

  Future<void> start() async {
    if (_running) return;
    _running = true;
    _connect();
  }

  void stop() {
    _running = false;
    _cancelToken?.cancel();
    _cancelToken = null;
  }

  Future<void> _connect() async {
    while (_running) {
      try {
        final dio = _dio;
        if (dio == null || !AppSettings().isLoggedIn) {
          await Future.delayed(const Duration(seconds: 2));
          continue;
        }

        _cancelToken = CancelToken();
        final response = await dio.get<ResponseBody>(
          '/events',
          options: Options(
            responseType: ResponseType.stream,
            headers: {
              'Accept': 'text/event-stream',
              if (_lastEventId != '0') 'Last-Event-ID': _lastEventId,
            },
          ),
          cancelToken: _cancelToken,
        );

        final stream = response.data?.stream;
        if (stream == null) continue;

        String buffer = '';
        await for (final chunk in stream) {
          if (!_running) break;
          buffer += utf8.decode(chunk);
          while (buffer.contains('\n\n')) {
            final index = buffer.indexOf('\n\n');
            final block = buffer.substring(0, index);
            buffer = buffer.substring(index + 2);
            _parseBlock(block);
          }
        }
      } catch (_) {
        if (!_running) break;
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  void _parseBlock(String block) {
    String? id;
    String? event;
    String? data;

    for (final line in block.split('\n')) {
      if (line.startsWith('id:')) {
        id = line.substring(3).trim();
      } else if (line.startsWith('event:')) {
        event = line.substring(6).trim();
      } else if (line.startsWith('data:')) {
        data = line.substring(5).trim();
      }
    }

    if (id == null || event == null || data == null) return;
    _lastEventId = id;

    dynamic parsed;
    try {
      parsed = jsonDecode(data);
    } catch (_) {
      parsed = data;
    }

    if (event == 'ticket.updated' && parsed is Map<String, dynamic>) {
      parsed = TicketModel.fromJson(parsed).toEntity();
    } else if (event == 'ticket.reply' && parsed is Map<String, dynamic>) {
      final replyJson = parsed['reply'];
      if (replyJson is Map<String, dynamic>) {
        parsed = {
          'ticketId': parsed['ticketId'],
          'reply': ReplyModel.fromJson(replyJson).toEntity(),
        };
      }
    }

    _controller.add(SseEvent(id: id, type: event, data: parsed));
  }

  void dispose() {
    stop();
    _controller.close();
  }
}
