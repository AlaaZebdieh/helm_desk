import 'package:dio/dio.dart';

import 'api_client.dart';
import 'api_response.dart';
import '../errors/exceptions/server_exception.dart';
import '../errors/exceptions/network_exception.dart';
import '../errors/exceptions/unknown_exception.dart';
import '../errors/exceptions/unauthorized_exception.dart';

class DioClient implements ApiClient {
  final Dio _dio;

  DioClient(this._dio);

  @override
  Future<ApiResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);

      return ApiResponse.success(
        response.data["data"] ?? response.data,
        response.statusCode ?? 200,
      );
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
  }) async {
    try {
      final data = formDataIsEnabled ? FormData.fromMap(body ?? {}) : body;

      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return ApiResponse.success(
        response.data["data"] ?? response.data,
        response.statusCode ?? 200,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ApiResponse> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: body,
        queryParameters: queryParameters,
      );

      return ApiResponse.success(
        response.data["data"] ?? response.data,
        response.statusCode ?? 200,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ApiResponse> delete(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: body,
        queryParameters: queryParameters,
      );

      return ApiResponse.success(
        response.data["data"] ?? response.data,
        response.statusCode ?? 200,
      );
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

    // 1️⃣ استخراج الرسالة
    final serverMessage = responseData is Map && responseData["message"] != null
        ? responseData["message"].toString()
        : null;

    final message = serverMessage ?? e.message;

    // 2️⃣ تحديد هل نعرض رسالة السيرفر أم لا
    final isClientError = statusCode != null && statusCode < 500;

    // -------------------------
    // 3️⃣ ترتيب الخطأ (Standard)
    // -------------------------

    switch (e.type) {
      // 🔹 1) مشاكل الاتصال والتوقيت
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkException(statusCode, "Network error", responseData);

      // 🔹 2) SSL certificate مشكلة
      case DioExceptionType.badCertificate:
        return NetworkException(
          statusCode,
          "Bad SSL Certificate",
          responseData,
        );

      // 🔹 3) السيرفر رد بخطأ (statusCode موجود)
      case DioExceptionType.badResponse:
        return _handleBadResponse(
          statusCode,
          message,
          responseData,
          isClientError,
        );

      // 🔹 4) تم إلغاء الطلب
      case DioExceptionType.cancel:
        return UnknownException(statusCode, "Request canceled", responseData);

      // 🔹 5) Unknown
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

    // if (statusCode == 403) {
    //   return UnauthorizedException(
    //     statusCode,
    //     isClientError ? message : "Access Denied",
    //     data,
    //   );
    // }

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
