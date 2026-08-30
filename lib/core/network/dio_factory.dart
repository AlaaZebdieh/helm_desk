import 'dart:io';
import 'package:dio/io.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../app/config/app_config.dart';
import 'interceptors/logging_interceptor.dart';

class DioFactory {
  final BaseOptions? baseOptions;
  final List<Interceptor>? interceptors;
  final Map<String, String>? globalHeaders;

  DioFactory({this.baseOptions, this.interceptors, this.globalHeaders});

  Dio createDio({String? overrideBaseUrl}) {
    final dio = Dio(
      baseOptions ??
          BaseOptions(
            baseUrl: overrideBaseUrl ?? AppConfig.baseUrl,
            connectTimeout: const Duration(seconds: AppConfig.timeoutSeconds),
            receiveTimeout: const Duration(seconds: AppConfig.timeoutSeconds),
            responseType: ResponseType.json,
            maxRedirects: 10,
            followRedirects: false,
            validateStatus: (status) => status != null && status < 400,
            headers: globalHeaders ?? {'Content-Type': 'application/json'},
          ),
    );

    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      HttpClient httpClient = HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => false;
      return httpClient;
    };

    if (interceptors != null) {
      dio.interceptors.addAll(interceptors!);
    }

    if (kDebugMode) {
      dio.interceptors.add(LoggingInterceptor());
    }

    return dio;
  }
}
