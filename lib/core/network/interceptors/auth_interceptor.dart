// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../app/config/app_settings.dart';
import '../../../app/helpers/dialog_helper.dart';
import '../../../app/navigation/app_router.dart';
import '../../../app/navigation/navigation_service.dart';
import '../../../app/utils/extensions/context_extensions.dart';

class AuthInterceptor extends Interceptor {
  final NavigationService navigationService;

  bool _isHandling401 = false;

  AuthInterceptor({required this.navigationService});

  bool _isAuthPath(String path) =>
      path.contains('/auth/login') || path.contains('/auth/refresh');

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 &&
        !_isAuthPath(err.requestOptions.path)) {
      await _handleSessionExpired();
    }
    super.onError(err, handler);
  }

  Future<void> _handleSessionExpired() async {
    if (_isHandling401) return;
    _isHandling401 = true;

    await AppSettings().clearSession();

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
        navigationService.pushReplacementNamed(Routes.loginRoute);
      },
    );

    FocusManager.instance.primaryFocus?.unfocus();
  }
}
