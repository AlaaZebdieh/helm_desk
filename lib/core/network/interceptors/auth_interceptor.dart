// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../app/config/app_settings.dart';
import '../../../app/helpers/dialog_helper.dart';
import '../../../app/navigation/navigation_service.dart';
import '../../../app/utils/extensions/context_extensions.dart';

class AuthInterceptor extends Interceptor {
  final NavigationService navigationService;

  bool _isHandling401 = false;

  AuthInterceptor({required this.navigationService});

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.statusCode == 401) {
      await _handle401();
    }
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _handle401();
    }
    super.onError(err, handler);
  }

  Future<void> _handle401() async {
    if (_isHandling401) return;
    _isHandling401 = true;

    await AppSettings().clearToken();

    /// Close any open dialogs just in case
    final ctx = navigationService.navigationKey.currentContext;
    if (ctx == null) {
      _isHandling401 = false;
      return;
    }
    Navigator.of(ctx, rootNavigator: true).popUntil((route) => route.isFirst);

    await _showSessionExpiredDialog();
  }

  Future<void> _showSessionExpiredDialog() async {
    final ctx = navigationService.navigationKey.currentContext;
    if (ctx == null) {
      _isHandling401 = false;
      return;
    }

    DialogHelper.showWarningDialog(
      context: ctx,
      onDialogClosed: () => _isHandling401 = false,
      barrierDismissible: false,
      msg: ctx.translate("your_session_has_expired_log_in_again"),
      onClickYes: () {
        Navigator.pop(ctx);
        // navigationService.pushNamed(Routes.loginRoute);
      },
    );

    /// Unfocus keyboard
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
