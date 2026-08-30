import 'failures.dart';

/// فشل بالتعامل مع التخزين المحلي
class CacheFailure extends Failure {
  CacheFailure({super.code, super.msg, super.data});
}
