import 'failures.dart';

/// فشل تنزيل الملف
class FileDownloadFailure extends Failure {
  FileDownloadFailure({super.code, super.msg, super.data});
}
