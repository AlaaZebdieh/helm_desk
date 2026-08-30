import 'failures.dart';

/// فشل عند المصادقة
class UnauthorizedFailure extends Failure {
  UnauthorizedFailure({super.code, super.msg, super.data});
}