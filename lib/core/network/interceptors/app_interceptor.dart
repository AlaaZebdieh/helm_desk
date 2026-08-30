import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../app/config/app_settings.dart';

class AppInterceptor extends Interceptor {
  final PackageInfo packageInfo;
  AppInterceptor({required this.packageInfo});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (AppSettings().isLoggedIn) {
      options.headers["Authorization"] = "Bearer ${AppSettings().token}";
    }

    options.headers["Accept"] = "application/json";
    options.headers["Content-Type"] = "application/json";
    options.headers["X-Platform"] = AppSettings().platform;
    options.headers["X-Locale"] = AppSettings().currentLang;
    options.headers["X-Current-Version"] = packageInfo.version;

    options.headers["User-Agent"] =
        "MOFA SY ${AppSettings().platform}/${packageInfo.version}";

    super.onRequest(options, handler);
  }
}
