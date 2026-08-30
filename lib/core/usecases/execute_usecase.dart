import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../errors/failures/failures.dart';

mixin UsecaseExecutor<CubitState extends Equatable> on Cubit<CubitState> {
  Future<void> executeUsecase<T>(
    Future<Either<Failure, T>> Function() usecase, {
    required void Function() onLoading,
    required void Function(T result) onSuccess,
    required void Function(Failure failure) onFailure,
  }) async {
    onLoading();
    final result = await usecase();
    result.fold(onFailure, onSuccess);
  }
}
