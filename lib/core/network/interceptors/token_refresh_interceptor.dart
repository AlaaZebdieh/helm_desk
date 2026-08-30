import 'dart:async';

import 'package:dio/dio.dart';

import '../../../app/config/app_config.dart';
import '../../../app/config/app_settings.dart';
import '../api_error_utils.dart';

class TokenRefreshInterceptor extends Interceptor {
  Dio? _dio;
  final Dio _refreshDio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: AppConfig.timeoutSeconds),
      receiveTimeout: const Duration(seconds: AppConfig.timeoutSeconds),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  Completer<String?>? _refreshCompleter;

  void attach(Dio dio) => _dio = dio;

  bool _isAuthPath(String path) =>
      path.contains('/auth/login') || path.contains('/auth/refresh');

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final path = err.requestOptions.path;

    if (statusCode != 401 || _isAuthPath(path)) {
      return handler.next(err);
    }

    final errorCode = parseApiErrorCode(err.response?.data);
    if (errorCode != 'TOKEN_EXPIRED') {
      return handler.next(err);
    }

    final dio = _dio;
    if (dio == null) return handler.next(err);

    try {
      final newToken = await _refreshAccessToken();
      if (newToken == null || newToken.isEmpty) {
        return handler.next(err);
      }

      final options = err.requestOptions;
      options.headers['Authorization'] = 'Bearer $newToken';
      final response = await dio.fetch(options);
      return handler.resolve(response);
    } catch (_) {
      return handler.next(err);
    }
  }

  Future<String?> _refreshAccessToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<String?>();
    try {
      final refreshToken = AppSettings().refreshToken;
      if (refreshToken.isEmpty) {
        _refreshCompleter!.complete(null);
        return null;
      }

      final response = await _refreshDio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data is Map) {
        final accessToken = response.data['accessToken']?.toString();
        if (accessToken != null && accessToken.isNotEmpty) {
          await AppSettings().setToken(accessToken);
          _refreshCompleter!.complete(accessToken);
          return accessToken;
        }
      }

      _refreshCompleter!.complete(null);
      return null;
    } catch (_) {
      _refreshCompleter!.complete(null);
      return null;
    } finally {
      _refreshCompleter = null;
    }
  }
}
