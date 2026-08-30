import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures/failures.dart';
import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/startup_repository.dart';

class GetSavedLangUsecase implements Usecase<String?, NoParams> {
  final StartupRepository startupRepository;

  GetSavedLangUsecase({required this.startupRepository});

  @override
  Future<Either<Failure, String?>> call(NoParams params) async =>
      await startupRepository.getSavedLang();
}
