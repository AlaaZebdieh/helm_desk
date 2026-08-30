import 'package:dio/dio.dart';

import 'api_client.dart';
import 'api_error_utils.dart';
import 'api_response.dart';
import '../errors/exceptions/network_exception.dart';
import '../errors/exceptions/server_exception.dart';
import '../errors/exceptions/unauthorized_exception.dart';
import '../errors/exceptions/unknown_exception.dart';

class DioClient implements ApiClient {
  final Dio _dio;

  DioClient(this._dio);

  Options _options(Map<String, String>? headers) {
    if (headers == null || headers.isEmpty) return Options();
    return Options(headers: headers);
  }

  Map<String, List<String>> _normalizeHeaders(Map<String, dynamic>? raw) {
    if (raw == null) return {};
    return raw.map(
      (key, value) => MapEntry(
        key.toLowerCase(),
        value is List ? value.map((e) => e.toString()).toList() : [value.toString()],
      ),
    );
  }

  ApiResponse _toResponse(Response response) {
    final data = response.data;
    final payload = data is Map && data.containsKey('data') ? data['data'] : data;
    return ApiResponse.success(
      payload,
      response.statusCode ?? 200,
      headers: _normalizeHeaders(response.headers.map),
    );
  }

  @override
  Future<ApiResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: _options(headers),
      );
      return _toResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ApiResponse> post(
    String path, {
    Map<String, dynamic>? body,
    bool formDataIsEnabled = false,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final data = formDataIsEnabled ? FormData.fromMap(body ?? {}) : body;
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _options(headers),
      );
      return _toResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ApiResponse> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: body,
        queryParameters: queryParameters,
        options: _options(headers),
      );
      return _toResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ApiResponse> patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: body,
        queryParameters: queryParameters,
        options: _options(headers),
      );
      return _toResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ApiResponse> delete(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: body,
        queryParameters: queryParameters,
        options: _options(headers),
      );
      return _toResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ApiResponse> download(
    String url,
    String savePath, {
    Function(int received, int total)? onProgress,
  }) async {
    try {
      await _dio.download(url, savePath, onReceiveProgress: onProgress);
      return ApiResponse.success({}, 200);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;
    final serverMessage = parseApiErrorMessage(responseData);
    final message = serverMessage ?? e.message;
    final isClientError = statusCode != null && statusCode < 500;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkException(statusCode, "Network error", responseData);

      case DioExceptionType.badCertificate:
        return NetworkException(
          statusCode,
          "Bad SSL Certificate",
          responseData,
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(
          statusCode,
          message,
          responseData,
          isClientError,
        );

      case DioExceptionType.cancel:
        return UnknownException(statusCode, "Request canceled", responseData);

      case DioExceptionType.unknown:
        return UnknownException(
          statusCode,
          isClientError ? message : "Unexpected error",
          responseData,
        );
    }
  }

  Exception _handleBadResponse(
    int? statusCode,
    String? message,
    dynamic data,
    bool isClientError,
  ) {
    if (statusCode == 401) {
      return UnauthorizedException(
        statusCode,
        isClientError ? message : "Unauthorized",
        data,
      );
    }

    if (statusCode != null) {
      if (statusCode > 401 && statusCode < 500) {
        return ServerException(
          statusCode,
          isClientError ? message : "Bad Request",
          data,
        );
      } else if (statusCode >= 500) {
        return ServerException(statusCode, "Server error", data);
      }
    }

    return ServerException(
      statusCode,
      isClientError ? message : "Unexpected server response",
      data,
    );
  }
}
