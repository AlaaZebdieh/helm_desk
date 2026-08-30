import 'failures.dart';

/// فشل عام للسيرفر
class ServerFailure extends Failure {
  ServerFailure({super.code, super.msg, super.data});
}