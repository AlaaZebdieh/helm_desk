import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

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
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final endTime = DateTime.now();
    final duration = endTime.difference(_startTime!);

    log('''
===================== ✅ RESPONSE =====================
⬅️  STATUS: ${response.statusCode}
⬅️  URL: ${response.requestOptions.uri}
⏱️  TIME: ${duration.inMilliseconds}ms

📌 DATA:
${_formatData(response.data)}

=======================================================
''');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final endTime = DateTime.now();
    final duration = _startTime != null
        ? endTime.difference(_startTime!)
        : null;

    log('''
===================== ❌ ERROR =====================
❗ URL: ${err.requestOptions.uri}
❗ MESSAGE: ${err.message}
❗ STATUS: ${err.response?.statusCode}
⏱️ TIME: ${duration?.inMilliseconds}ms

📌 ERROR DATA:
${_formatData(err.response?.data)}

=======================================================
''');

    super.onError(err, handler);
  }

  // ---------- Helpers ---------- //

  String _prettyMap(Map map) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(map);
  }

  String _formatData(dynamic data) {
    try {
      if (data == null) return "null";
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
