import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures/failures.dart';
import '../entities/agent.dart';

abstract class AuthRepository {
  Future<Either<Failure, Agent>> login({
    required String username,
    required String password,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, bool>> isLoggedIn();
}
