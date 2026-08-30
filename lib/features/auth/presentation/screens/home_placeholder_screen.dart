import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/config/app_settings.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../app/screens/main_screen_theme.dart';
import '../../../../app/utils/extensions/context_extensions.dart';
import '../../../../app/widgets/app_button.dart';
import '../../../../core/services/sse_service.dart';
import '../../../../core/usecases/no_params.dart';
import '../../../../injection_container.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../../tickets/presentation/screens/inbox_screen.dart';

class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    sl<SseService>().stop();
    await sl<LogoutUsecase>()(NoParams());
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, Routes.loginRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final agent = AppSettings().agent;

    return MainScreenTheme(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${context.translate('welcome_agent')} ${agent?.name ?? ''}',
              style: context.theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            AppButton(
              text: context.translate('open_inbox'),
              onClickEvent: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InboxScreen()),
                );
              },
            ),
            SizedBox(height: 12.h),
            AppButton(
              text: context.translate('logout'),
              onClickEvent: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}
