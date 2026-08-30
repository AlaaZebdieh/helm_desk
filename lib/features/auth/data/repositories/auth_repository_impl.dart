import 'package:dartz/dartz.dart';

import '../../../../app/config/app_settings.dart';
import '../../../../core/errors/failures/failures.dart';
import '../../../../core/utils/safe_api_call.dart';
import '../../domain/entities/agent.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Agent>> login({
    required String username,
    required String password,
  }) async {
    return safeApiCall(() async {
      final response = await remoteDataSource.login(
        username: username,
        password: password,
      );
      final agent = response.agent.toEntity();
      await AppSettings().setSession(
        accessToken: response.accessToken,
        refresh: response.refreshToken,
        agentData: agent,
      );
      return agent;
    });
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return safeApiCall(() => AppSettings().clearSession());
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    return Right(AppSettings().isLoggedIn);
  }
}
