import 'failures.dart';

/// فشل غير متوقع
class UnknownFailure extends Failure {
  UnknownFailure({super.code, super.msg, super.data});
}
