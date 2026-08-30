import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/startup_repository.dart';

class ChangeLangUsecase implements Usecase<void, String> {
  final StartupRepository startupRepository;

  ChangeLangUsecase({required this.startupRepository});

  @override
  Future<Either<Failure, void>> call(String lang) async =>
      await startupRepository.changeLang(lang);
}
