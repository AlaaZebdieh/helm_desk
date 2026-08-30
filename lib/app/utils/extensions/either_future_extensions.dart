import 'package:dartz/dartz.dart';
import 'dart:developer';

import '../../../core/errors/failures/failures.dart';

extension EitherFutureX<T> on Future<Either<Failure, T>> {
  Future<void> handle({
    required void Function(T) onSuccess,
    void Function(Failure)? onFailure,
  }) async {
    final result = await this;
    result.fold((failure) {
      if (onFailure != null) {
        onFailure(failure);
      } else {
        log(failure.msg ?? "Unknown failure");
      }
    }, (value) => onSuccess(value));
  }
}
