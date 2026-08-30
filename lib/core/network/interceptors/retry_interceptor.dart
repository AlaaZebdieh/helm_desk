import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  static const _maxRetries = 2;
  Dio? _dio;

  void attach(Dio dio) => _dio = dio;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    if (statusCode != 429) return handler.next(err);

    final dio = _dio;
    if (dio == null) return handler.next(err);

    final retryAfter = err.response?.headers.value('retry-after');
    final seconds = int.tryParse(retryAfter ?? '') ?? 5;
    final retryCount = (err.requestOptions.extra['retryCount'] as int?) ?? 0;

    if (retryCount >= _maxRetries) return handler.next(err);

    await Future.delayed(Duration(seconds: seconds));

    try {
      final options = err.requestOptions;
      options.extra['retryCount'] = retryCount + 1;
      final response = await dio.fetch(options);
      return handler.resolve(response);
    } catch (e) {
      if (e is DioException) return handler.next(e);
      return handler.next(err);
    }
  }
}
