import 'failures.dart';

/// فشل بل تحويل من json لل model
class DataParsingFailure extends Failure {
  DataParsingFailure({super.code, super.msg, super.data});
}
