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
import 'core/storage/shared_prefs_service.dart';
import 'core/services/dynamic_link_service.dart';
import 'core/storage/local_storage_service.dart';
import 'core/services/file_download_service.dart';
import 'core/services/notifications_service.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/observers/app_lifecycle_observer.dart';
import 'core/network/interceptors/app_interceptor.dart';
import 'core/network/interceptors/auth_interceptor.dart';
import 'core/network/interceptors/app_updates_interceptor.dart';

import 'app/shared/injection_container.dart' as di_shared;
import 'features/startup/injection_container.dart' as di_startup;

final sl = GetIt.instance;

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();

  if (kDebugMode) {
    Bloc.observer = AppBlocObserver();
  }

  AppLifecycleObserver().startObserving();

  //! Screen Orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //! Network
  sl.registerLazySingleton<AppInterceptor>(
    () => AppInterceptor(packageInfo: sl()),
  );
  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(navigationService: sl()),
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
        sl<AuthInterceptor>(),
        sl<AppUpdatesInterceptor>(),
      ],
    ),
  );
  sl.registerLazySingleton<Dio>(() => sl<DioFactory>().createDio());
  sl.registerLazySingleton<ApiClient>(() => DioClient(sl<Dio>()));

  //! Services
  sl.registerLazySingleton(() => NavigationService());
  sl.registerLazySingleton(() => FileUploadService(sl<Dio>()));
  sl.registerLazySingleton(() => FileDownloadService(sl<Dio>()));
  sl.registerLazySingleton(() => DynamicLinkService(navigationService: sl()));
  sl.registerLazySingleton(() => NotificationsService(navigationService: sl()));

  //! Storage
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<LocalStorageService>(
    () => SharedPrefsService(sharedPrefs),
    instanceName: "sharedPrefs",
  );
  sl.registerLazySingleton<LocalStorageService>(
    () => SecureStorageService(),
    instanceName: "secureStorage",
  );

  //! Other
  final packageInfo = await PackageInfo.fromPlatform();
  sl.registerLazySingleton(() => packageInfo);

  //! Feature DI
  await di_shared.init();
  await di_startup.init();

  //! Settings
  await AppSettings().init();
}
