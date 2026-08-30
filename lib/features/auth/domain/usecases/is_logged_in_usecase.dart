import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures/failures.dart';
import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class IsLoggedInUsecase implements Usecase<bool, NoParams> {
  final AuthRepository authRepository;

  IsLoggedInUsecase({required this.authRepository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return authRepository.isLoggedIn();
  }
}
