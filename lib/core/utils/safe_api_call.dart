import 'package:dartz/dartz.dart';

import '../errors/failures/failures.dart';
import 'error_mapper.dart';

/// Wrapper عام لأي Future يقوم بتحويل أي Exception إلى Failure
Future<Either<Failure, T>> safeApiCall<T>(Future<T> Function() apiCall) async {
  try {
    final result = await apiCall();
    return Right(result);
  } catch (e) {
    // تحويل Exception إلى Failure باستخدام error_mapper
    return Left(mapExceptionToFailure(e as Exception));
  }
}
