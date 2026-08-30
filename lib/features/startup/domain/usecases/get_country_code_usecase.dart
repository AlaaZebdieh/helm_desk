import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';
import '../repositories/startup_repository.dart';
import '../../../../core/usecases/no_params.dart';
import '../../../../core/errors/failures/failures.dart';

class GetCountryCodeUsecase implements Usecase<void, NoParams> {
  final StartupRepository startupRepository;

  GetCountryCodeUsecase({required this.startupRepository});
  @override
  Future<Either<Failure, void>> call(NoParams params) =>
      startupRepository.getCountryCode();
}
