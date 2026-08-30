import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Reads a streamed error body (e.g. SSE `/events` with `ResponseType.stream`).
Future<Map<String, dynamic>?> responseBodyToMap(ResponseBody body) async {
  final builder = BytesBuilder();
  try {
    await for (final chunk in body.stream) {
      builder.add(chunk);
    }
  } catch (_) {
    return null;
  }

  if (builder.isEmpty) return null;
  return normalizeResponseData(utf8.decode(builder.toBytes()));
}

/// Reads [ResponseBody] once for logging — returns pretty JSON text and parsed map.
Future<({String logText, Map<String, dynamic>? map})> readResponseBodyForLog(
  ResponseBody body,
) async {
  final builder = BytesBuilder();
  try {
    await for (final chunk in body.stream) {
      builder.add(chunk);
    }
  } catch (_) {
    return (logText: '<failed to read ResponseBody>', map: null);
  }

  if (builder.isEmpty) {
    return (logText: 'null', map: null);
  }

  final raw = utf8.decode(builder.toBytes());
  final map = normalizeResponseData(raw);
  if (map != null) {
    return (
      logText: const JsonEncoder.withIndent('  ').convert(map),
      map: map,
    );
  }
  return (logText: raw, map: null);
}

/// Normalizes [data] to a `Map` whether Dio decoded JSON or left a raw String.
Map<String, dynamic>? normalizeResponseData(dynamic data) {
  if (data == null) return null;

  if (data is Map<String, dynamic>) return data;

  if (data is Map) {
    return data.map((key, value) => MapEntry(key.toString(), value));
  }

  if (data is String && data.isNotEmpty) {
    try {
      final decoded = jsonDecode(data);
      if (decoded is Map) {
        return decoded.map((key, value) => MapEntry(key.toString(), value));
      }
    } catch (_) {
      return null;
    }
  }

  return null;
}

/// Async variant — required when `response.data` is [ResponseBody].
Future<Map<String, dynamic>?> normalizeResponseDataAsync(dynamic data) async {
  if (data is ResponseBody) {
    return responseBodyToMap(data);
  }
  return normalizeResponseData(data);
}

String? _extractErrorCode(Map<String, dynamic>? map) {
  if (map == null) return null;
  final error = map['error'];
  if (error is Map) {
    final raw = error['code'];
    if (raw != null) return raw.toString();
  }
  return null;
}

/// Parses error code from a [Response], reading [ResponseBody] when needed.
///
/// Replaces `response.data` with the parsed `Map` so downstream code sees JSON.
Future<String?> parseApiErrorCodeAsync(
  Response? response, {
  String? debugTag,
}) async {
  if (response == null) return null;

  final originalType = response.data.runtimeType;
  final map = await normalizeResponseDataAsync(response.data);
  if (map != null) {
    response.data = map;
  }

  final code = _extractErrorCode(map);

  if (kDebugMode && debugTag != null) {
    developer.log(
      '[401/$debugTag] response.data.runtimeType: $originalType → ${response.data.runtimeType}\n'
      '[401/$debugTag] error.code: $code',
      name: 'ApiErrorParser',
    );
  }

  return code;
}

/// Sync parser — only works when [data] is already a Map or JSON String.
String? parseApiErrorCode(dynamic data, {String? debugTag}) {
  final map = normalizeResponseData(data);
  final code = _extractErrorCode(map);

  if (kDebugMode && debugTag != null) {
    developer.log(
      '[401/$debugTag] response.data.runtimeType: ${data.runtimeType}\n'
      '[401/$debugTag] error.code: $code',
      name: 'ApiErrorParser',
    );
  }

  return code;
}

String? parseApiErrorMessage(dynamic data) {
  final map = normalizeResponseData(data);
  if (map == null) return null;

  final error = map['error'];
  if (error is Map && error['message'] != null) {
    return error['message'].toString();
  }
  if (map['message'] != null) {
    return map['message'].toString();
  }
  return null;
}

Future<String?> parseApiErrorMessageAsync(Response? response) async {
  if (response == null) return null;
  final map = await normalizeResponseDataAsync(response.data);
  if (map != null) {
    response.data = map;
  }
  return parseApiErrorMessage(map);
}
