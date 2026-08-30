import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures/failures.dart';
import '../../../../core/usecases/execute_usecase.dart';
import '../../domain/usecases/login_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> with UsecaseExecutor<LoginState> {
  final LoginUsecase loginUsecase;

  LoginCubit({required this.loginUsecase}) : super(LoginInitial());

  Future<void> login({required String username, required String password}) async {
    await executeUsecase(
      () => loginUsecase(LoginParams(username: username, password: password)),
      onLoading: () => emit(LoginLoading()),
      onSuccess: (_) => emit(const LoginSuccess()),
      onFailure: (failure) => emit(LoginFailure(failure)),
    );
  }
}
