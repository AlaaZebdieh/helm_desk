import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/agent.dart';
import '../repositories/auth_repository.dart';

class LoginParams extends Equatable {
  final String username;
  final String password;

  const LoginParams({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class LoginUsecase implements Usecase<Agent, LoginParams> {
  final AuthRepository authRepository;

  LoginUsecase({required this.authRepository});

  @override
  Future<Either<Failure, Agent>> call(LoginParams params) {
    return authRepository.login(
      username: params.username,
      password: params.password,
    );
  }
}
