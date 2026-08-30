import 'package:flutter/material.dart';

import '../../../../app/helpers/dialog_helper.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../app/utils/extensions/context_extensions.dart';
import '../../../../core/services/sse_service.dart';
import '../../../../core/usecases/no_params.dart';
import '../../../../injection_container.dart';
import '../../domain/usecases/logout_usecase.dart';

class LogoutHelper {
  LogoutHelper._();

  static void logout(BuildContext context) {
    DialogHelper.showWarningDialog(
      context: context,
      msg: context.translate('logout_confirmation'),
      textYes: context.translate('logout'),
      onClickYes: () {
        Navigator.pop(context);
        _performLogout(context);
      },
    );
  }

  static Future<void> _performLogout(BuildContext context) async {
    sl<SseService>().stop();
    await sl<LogoutUsecase>()(NoParams());
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, Routes.loginRoute);
    }
  }
}
