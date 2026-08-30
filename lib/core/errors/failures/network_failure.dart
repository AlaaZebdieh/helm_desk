import 'failures.dart';

/// فشل بالاتصال بالانترنت
class NetworkFailure extends Failure {
  NetworkFailure({super.code, super.msg, super.data});
}