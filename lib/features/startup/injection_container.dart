import 'package:get_it/get_it.dart';

import 'domain/usecases/change_lang_usecase.dart';
import 'domain/usecases/change_theme_usecase.dart';
import 'domain/usecases/get_saved_lang_usecase.dart';
import 'domain/repositories/startup_repository.dart';
import 'domain/usecases/get_saved_theme_usecase.dart';
import 'domain/usecases/get_country_code_usecase.dart';
import 'data/repositories/startup_repository_impl.dart';
import 'data/datasources/startup_local_datasource.dart';
import 'presentation/cubit/startup_cubit.dart';
import 'data/datasources/startup_remote_data_source.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Blocs
  sl.registerFactory<StartupCubit>(
    () => StartupCubit(
      getSavedLangUsecase: sl(),
      getSavedThemeUsecase: sl(),
      changeLangUsecase: sl(),
      changeThemeUsecase: sl(),
      getCountryCodeUsecase: sl(),
    ),
  );

  //! Use cases
  sl.registerLazySingleton<GetSavedLangUsecase>(
    () => GetSavedLangUsecase(startupRepository: sl()),
  );
  sl.registerLazySingleton<GetSavedThemeUsecase>(
    () => GetSavedThemeUsecase(startupRepository: sl()),
  );
  sl.registerLazySingleton<ChangeLangUsecase>(
    () => ChangeLangUsecase(startupRepository: sl()),
  );
  sl.registerLazySingleton<ChangeThemeUsecase>(
    () => ChangeThemeUsecase(startupRepository: sl()),
  );
  sl.registerLazySingleton<GetCountryCodeUsecase>(
    () => GetCountryCodeUsecase(startupRepository: sl()),
  );

  //! Repository
  sl.registerLazySingleton<StartupRepository>(
    () => StartupRepositoryImpl(
      startupLocalDatasource: sl(),
      startupRemoteDataSource: sl(),
    ),
  );

  //! Data Sources
  sl.registerLazySingleton<StartupLocalDatasource>(
    () => StartupLocalDatasourceImpl(
      localStorageService: sl(instanceName: "sharedPrefs"),
    ),
  );
  sl.registerLazySingleton<StartupRemoteDataSource>(
    () => StartupRemoteDataSourceImpl(apiClient: sl()),
  );
}
