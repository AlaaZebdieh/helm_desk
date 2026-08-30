// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';

import '../../../core/errors/failures/google_auth_not_supported_failure.dart';
import '../../../core/errors/failures/google_auth_canceled_failure.dart';
import '../../../core/errors/failures/file_download_failure.dart';
import '../../../core/errors/failures/data_parsing_failure.dart';
import '../../../core/errors/failures/google_auth_failure.dart';
import '../../../core/errors/failures/unauthorized_failure.dart';
import '../../../core/errors/failures/file_upload_failure.dart';
import '../../../app/utils/extensions/context_extensions.dart';
import '../../../core/errors/failures/network_failure.dart';
import '../../../core/errors/failures/unknown_failure.dart';
import '../../../core/errors/failures/server_failure.dart';
import '../../../core/errors/failures/cache_failure.dart';
import '../../../core/errors/failures/failures.dart';
import '../../widgets/app_error_widget.dart';
import '../../helpers/toast_helper.dart';
import '../../config/app_config.dart';

extension FailureX on Failure {
  void showToast(BuildContext context) {
    final toast = ToastHelper();

    switch (this) {
      case NetworkFailure():
        toast.networkDisconnected(context);
        break;

      case ServerFailure(msg: final message, code: final code):
        if (message != null &&
            message.isNotEmpty &&
            (code != null && (code < 500 || AppConfig.isDebug))) {
          toast.error(context, msg: (_) => msg!);
        } else {
          toast.error(context);
        }
        break;

      case UnauthorizedFailure():
        break;

      case CacheFailure():
        toast.warning(
          context,
          msg: (ctx) => ctx.translate("cached_data_unavailable"),
        );
        break;

      case DataParsingFailure():
        toast.warning(
          context,
          msg: (ctx) => ctx.translate("data_processing_error"),
        );
        break;

      case FileUploadFailure():
        toast.error(context, msg: (ctx) => ctx.translate("file_upload_failed"));
        break;

      case FileDownloadFailure():
        toast.error(
          context,
          msg: (ctx) => ctx.translate("file_download_failed"),
        );
        break;

      case GoogleAuthNotSupportedFailure():
        toast.error(
          context,
          msg: (ctx) => ctx.translate(
              "google_signin_is_not_supported_on_your_device_please_choose_another"),
        );
        break;

      case GoogleAuthCanceledFailure():
        break;

      case GoogleAuthFailure():
        toast.error(
          context,
          msg: (ctx) => ctx.translate(
              "google_signin_failed_please_try_again_later_or_choose_another_signin_method"),
        );
        break;

      case UnknownFailure():
      default:
        toast.error(context, msg: (ctx) => ctx.translate("unexpected_error"));
        break;
    }
  }

  Widget appErrorWidget(BuildContext context, {VoidCallback? onPress}) {
    switch (this) {
      case NetworkFailure():
        return AppErrorWidget(
          mainText: context.translate("network_disconnected"),
          icon: Icons.wifi_off_rounded,
          onPress: onPress,
        );
      case ServerFailure(msg: final message, code: final code):
        if (message != null &&
            message.isNotEmpty &&
            (code != null && (code < 500 || AppConfig.isDebug))) {
          return AppErrorWidget(mainText: msg, onPress: onPress);
        }
        return AppErrorWidget(onPress: onPress);
      case UnauthorizedFailure():
        return const SizedBox.shrink();
      case CacheFailure():
        return AppErrorWidget(
            mainText: context.translate("cached_data_unavailable"),
            onPress: onPress);
      case DataParsingFailure():
        return AppErrorWidget(
            mainText: context.translate("data_processing_error"),
            onPress: onPress);
      case FileUploadFailure():
        return AppErrorWidget(
            mainText: context.translate("file_upload_failed"),
            onPress: onPress);
      case FileDownloadFailure():
        return AppErrorWidget(
            mainText: context.translate("file_download_failed"),
            onPress: onPress);
      case UnknownFailure():
      default:
        return AppErrorWidget(onPress: onPress);
    }
  }
}
