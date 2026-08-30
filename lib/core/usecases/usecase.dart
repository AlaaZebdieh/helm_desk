import 'package:dartz/dartz.dart';

import '../errors/failures/failures.dart';

abstract class Usecase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}
