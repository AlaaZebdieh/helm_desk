import '../errors/exceptions/google_auth_not_supported_exception.dart';
import '../errors/failures/google_auth_not_supported_failure.dart';
import '../errors/exceptions/google_auth_canceled_exception.dart';
import '../errors/failures/google_auth_canceled_failure.dart';
import '../errors/exceptions/file_download_exception.dart';
import '../errors/exceptions/data_parsing_exception.dart';
import '../errors/exceptions/unauthorized_exception.dart';
import '../errors/exceptions/google_auth_exception.dart';
import '../errors/exceptions/file_upload_exception.dart';
import '../errors/failures/file_download_failure.dart';
import '../errors/failures/data_parsing_failure.dart';
import '../errors/failures/unauthorized_failure.dart';
import '../errors/failures/google_auth_failure.dart';
import '../errors/exceptions/network_exception.dart';
import '../errors/exceptions/unknown_exception.dart';
import '../errors/failures/file_upload_failure.dart';
import '../errors/exceptions/server_exception.dart';
import '../errors/failures/unknown_failure.dart';
import '../errors/failures/network_failure.dart';
import '../errors/failures/server_failure.dart';
import '../errors/failures/cache_failure.dart';
import '../errors/failures/failures.dart';

/// تحويل أي Exception إلى Failure مناسب
Failure mapExceptionToFailure(Exception e) {
  if (e is ServerException) {
    return ServerFailure(code: e.code, msg: e.msg, data: e.data);
  }

  if (e is NetworkException) {
    return NetworkFailure(code: e.code, msg: e.msg, data: e.data);
  }

  if (e is UnauthorizedException) {
    return UnauthorizedFailure(code: e.code, msg: e.msg, data: e.data);
  }

  if (e is DataParsingException) {
    return DataParsingFailure(code: e.code, msg: e.msg, data: e.data);
  }

  if (e is UnknownException) {
    return UnknownFailure(code: e.code, msg: e.msg, data: e.data);
  }

  if (e is FileUploadException) {
    return FileUploadFailure(code: e.code, msg: e.msg, data: e.data);
  }

  if (e is FileDownloadException) {
    return FileDownloadFailure(code: e.code, msg: e.msg, data: e.data);
  }

  if (e is GoogleAuthNotSupportedException) {
    return GoogleAuthNotSupportedFailure(
      code: e.code,
      msg: e.msg,
      data: e.data,
    );
  }

  if (e is GoogleAuthCanceledException) {
    return GoogleAuthCanceledFailure(code: e.code, msg: e.msg, data: e.data);
  }

  if (e is GoogleAuthException) {
    return GoogleAuthFailure(code: e.code, msg: e.msg, data: e.data);
  }

  return CacheFailure(msg: e.toString());
}
