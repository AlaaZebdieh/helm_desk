import 'package:dartz/dartz.dart';

import '../../../../app/config/app_settings.dart';
import '../../../../core/utils/safe_api_call.dart';
import '../datasources/startup_local_datasource.dart';
import '../../../../core/errors/failures/failures.dart';
import '../datasources/startup_remote_data_source.dart';
import '../../domain/repositories/startup_repository.dart';

class StartupRepositoryImpl implements StartupRepository {
  final StartupLocalDatasource startupLocalDatasource;
  final StartupRemoteDataSource startupRemoteDataSource;

  StartupRepositoryImpl({
    required this.startupLocalDatasource,
    required this.startupRemoteDataSource,
  });

  @override
  Future<Either<Failure, String?>> getSavedLang() async {
    return await safeApiCall(() => startupLocalDatasource.getSavedLang());
  }

  @override
  Future<Either<Failure, String?>> getSavedTheme() async {
    return await safeApiCall(() => startupLocalDatasource.getSavedTheme());
  }

  @override
  Future<Either<Failure, void>> changeLang(String lang) async {
    return await safeApiCall(() => startupLocalDatasource.changeLang(lang));
  }

  @override
  Future<Either<Failure, void>> changeTheme(String theme) async {
    return await safeApiCall(() => startupLocalDatasource.changeTheme(theme));
  }

  @override
  Future<Either<Failure, void>> getCountryCode() async {
    return await safeApiCall(() async {
      final data = await startupRemoteDataSource.getCountryCode();
      AppSettings().countryCode = data;
    });
  }
}
