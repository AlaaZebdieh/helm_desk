import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/config/app_settings.dart';
import 'core/network/api_client.dart';
import 'core/network/dio_client.dart';
import 'core/network/dio_factory.dart';
import 'core/observers/bloc_observer.dart';
import 'app/navigation/navigation_service.dart';
import 'core/services/file_upload_service.dart';
import 'core/services/sse_service.dart';
import 'core/storage/shared_prefs_service.dart';
import 'core/services/dynamic_link_service.dart';
import 'core/storage/local_storage_service.dart';
import 'core/services/file_download_service.dart';
import 'core/services/notifications_service.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/observers/app_lifecycle_observer.dart';
import 'core/network/interceptors/app_interceptor.dart';
import 'core/network/interceptors/auth_interceptor.dart';
import 'core/network/interceptors/retry_interceptor.dart';
import 'core/network/interceptors/token_refresh_interceptor.dart';
import 'core/network/interceptors/app_updates_interceptor.dart';

import 'app/shared/injection_container.dart' as di_shared;
import 'features/startup/injection_container.dart' as di_startup;
import 'features/auth/injection_container.dart' as di_auth;
import 'features/tickets/injection_container.dart' as di_tickets;

final sl = GetIt.instance;

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    Bloc.observer = AppBlocObserver();
  }

  AppLifecycleObserver().startObserving();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  sl.registerLazySingleton<AppInterceptor>(
    () => AppInterceptor(packageInfo: sl()),
  );
  sl.registerLazySingleton<TokenRefreshInterceptor>(
    () => TokenRefreshInterceptor(),
  );
  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(navigationService: sl()),
  );
  sl.registerLazySingleton<RetryInterceptor>(
    () => RetryInterceptor(),
  );
  sl.registerLazySingleton<AppUpdatesInterceptor>(
    () => AppUpdatesInterceptor(
      packageInfo: sl(),
      navigationService: sl(),
      localStorageService: sl(instanceName: "sharedPrefs"),
    ),
  );
  sl.registerLazySingleton(
    () => DioFactory(
      interceptors: [
        sl<AppInterceptor>(),
        sl<TokenRefreshInterceptor>(),
        sl<AuthInterceptor>(),
        sl<RetryInterceptor>(),
        sl<AppUpdatesInterceptor>(),
      ],
    ),
  );
  sl.registerLazySingleton<Dio>(() {
    final dio = sl<DioFactory>().createDio();
    sl<TokenRefreshInterceptor>().attach(dio);
    sl<RetryInterceptor>().attach(dio);
    sl<SseService>().attach(dio);
    return dio;
  });
  sl.registerLazySingleton<ApiClient>(() => DioClient(sl<Dio>()));

  sl.registerLazySingleton(() => NavigationService());
  sl.registerLazySingleton(() => FileUploadService(sl<Dio>()));
  sl.registerLazySingleton(() => FileDownloadService(sl<Dio>()));
  sl.registerLazySingleton(() => DynamicLinkService(navigationService: sl()));
  sl.registerLazySingleton(() => NotificationsService(navigationService: sl()));
  sl.registerLazySingleton(() => SseService());

  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<LocalStorageService>(
    () => SharedPrefsService(sharedPrefs),
    instanceName: "sharedPrefs",
  );
  sl.registerLazySingleton<LocalStorageService>(
    () => SecureStorageService(),
    instanceName: "secureStorage",
  );

  final packageInfo = await PackageInfo.fromPlatform();
  sl.registerLazySingleton(() => packageInfo);

  await di_shared.init();
  await di_startup.init();
  await di_auth.init();
  await di_tickets.init();

  await AppSettings().init();
}
