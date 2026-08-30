import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures/failures.dart';
import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class LogoutUsecase implements Usecase<void, NoParams> {
  final AuthRepository authRepository;

  LogoutUsecase({required this.authRepository});

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return authRepository.logout();
  }
}
