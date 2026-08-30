import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures/failures.dart';

abstract class StartupRepository {
  Future<Either<Failure, String?>> getSavedLang();
  Future<Either<Failure, String?>> getSavedTheme();

  Future<Either<Failure, void>> changeLang(String lang);
  Future<Either<Failure, void>> changeTheme(String theme);

    Future<Either<Failure, void>> getCountryCode();
}
