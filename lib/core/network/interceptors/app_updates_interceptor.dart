import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../app/config/app_strings.dart';
import '../../../app/helpers/dialog_helper.dart';
import '../../storage/local_storage_service.dart';
import '../../../app/navigation/navigation_service.dart';
import '../../../app/utils/extensions/string_extensions.dart';
import '../../../app/utils/extensions/context_extensions.dart';

class AppUpdatesInterceptor extends Interceptor {
  final PackageInfo packageInfo;
  final NavigationService navigationService;
  final LocalStorageService localStorageService;

  bool _isDialogOpen = false;

  AppUpdatesInterceptor({
    required this.packageInfo,
    required this.navigationService,
    required this.localStorageService,
  });

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    await _checkAppUpdate(response);
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response != null) {
      await _checkAppUpdate(err.response!);
    }
    super.onError(err, handler);
  }

  Future<void> _checkAppUpdate(Response response) async {
    if (_isDialogOpen) return;

    final latestVersion = response.headers.value("X-Citizen-App-Version");
    final updateRequired =
        response.headers.value("X-Citizen-Update-Required") == "1";

    if (latestVersion == null) return;

    final lastVersionNum = _versionToNumber(latestVersion);
    final currentVersionNum = _versionToNumber(packageInfo.version);
    final alreadyShown = await localStorageService.containsKey(latestVersion);

    if (lastVersionNum != null &&
        currentVersionNum != null &&
        currentVersionNum < lastVersionNum &&
        (updateRequired || !alreadyShown)) {
      if (!alreadyShown) {
        await localStorageService.write(latestVersion, "");
      }

      await _showUpdateDialog(updateRequired);
    }
  }

  int? _versionToNumber(String version) {
    try {
      return int.parse(version.replaceAll(".", ""));
    } catch (_) {
      return null;
    }
  }

  Future<void> _showUpdateDialog(bool isMandatory) async {
    final ctx = navigationService.navigationKey.currentContext;
    if (ctx == null) return;

    _isDialogOpen = true;

    // أغلق أي dialog مفتوح قبل عرض التحديث
    Navigator.of(ctx, rootNavigator: true).popUntil((route) => route.isFirst);

    DialogHelper.showWarningDialog(
      context: ctx,
      barrierDismissible: !isMandatory,
      canPop: !isMandatory,
      msg: Platform.isAndroid
          ? ctx.translate("update_message_google")
          : ctx.translate("update_message_app_store"),
      textYes: ctx.translate("upgrade"),
      onClickYes: () {
        if (Platform.isAndroid) {
          AppStrings.linkAppOnGooglePlay.launchUrl;
        } else {
          AppStrings.linkAppOnAppStore.launchUrl;
        }
      },
      onClickNo: () {
        if (isMandatory) {
          SystemNavigator.pop();
        } else {
          Navigator.pop(ctx);
        }
      },
    );

    // بعد إغلاق الديالوج
    _isDialogOpen = false;
  }
}
