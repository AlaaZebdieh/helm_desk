import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

import '../api_error_utils.dart';

class LoggingInterceptor extends Interceptor {
  DateTime? _startTime;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _startTime = DateTime.now();

    log('''
===================== 🌐 REQUEST =====================
➡️  METHOD: ${options.method}
➡️  URL: ${options.uri}

📌 HEADERS:
${_prettyMap(options.headers)}

📌 BODY:
${_formatData(options.data)}

=======================================================
''');

    super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final endTime = DateTime.now();
    final duration = endTime.difference(_startTime!);

    log('''
===================== ✅ RESPONSE =====================
⬅️  STATUS: ${response.statusCode}
⬅️  URL: ${response.requestOptions.uri}
⏱️  TIME: ${duration.inMilliseconds}ms

📌 DATA:
${await _formatDataAsync(response.data, response.requestOptions)}

=======================================================
''');

    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final endTime = DateTime.now();
    final duration = _startTime != null
        ? endTime.difference(_startTime!)
        : null;

    String formatted;
    final data = err.response?.data;

    if (data is ResponseBody) {
      final content = await readResponseBodyForLog(data);
      formatted = content.logText;
      if (content.map != null) {
        err.response!.data = content.map;
      }
    } else {
      formatted = await _formatDataAsync(data, err.requestOptions);
    }

    log('''
===================== ❌ ERROR =====================
❗ URL: ${err.requestOptions.uri}
❗ MESSAGE: ${err.message}
❗ STATUS: ${err.response?.statusCode}
⏱️ TIME: ${duration?.inMilliseconds}ms

📌 ERROR DATA:
$formatted

=======================================================
''');

    handler.next(err);
  }

  // ---------- Helpers ---------- //

  String _prettyMap(Map map) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(map);
  }

  Future<String> _formatDataAsync(
    dynamic data,
    RequestOptions requestOptions,
  ) async {
    if (data == null) return 'null';

    if (data is ResponseBody) {
      if (_isLiveStream(requestOptions)) {
        final type = requestOptions.responseType;
        return '<stream ($type) — body not logged to preserve stream>';
      }

      final content = await readResponseBodyForLog(data);
      return content.logText;
    }

    return _formatData(data);
  }

  bool _isLiveStream(RequestOptions options) {
    return options.responseType == ResponseType.stream &&
        options.path.contains('/events');
  }

  String _formatData(dynamic data) {
    try {
      if (data == null) return 'null';
      if (data is String) {
        return data;
      }

      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(data);
    } catch (_) {
      return data.toString();
    }
  }
}
