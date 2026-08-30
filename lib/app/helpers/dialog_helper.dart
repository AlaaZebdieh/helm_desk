import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../gen/assets.gen.dart';
import '../widgets/app_button.dart';
import '../theme/app_text_styles.dart';
import '../utils/extensions/context_extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogHelper {
  static void showWarningDialog({
    required String msg,
    required BuildContext context,
    required VoidCallback onClickYes,
    String? textYes,
    VoidCallback? onClickNo,
    Function(bool, dynamic)? onPopInvoked,
    bool canPop = true,
    bool barrierDismissible = true,
    VoidCallback? onDialogClosed,
  }) {
    final customColors = context.customColors;
    final colors = context.colors;

    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: barrierDismissible,
      barrierColor: colors.shadow.withValues(alpha: 0.1),
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return PopScope(
          canPop: canPop,
          onPopInvokedWithResult: onPopInvoked,
          child: Material(
            type: MaterialType.transparency,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 24.w,
                    ).copyWith(bottom: context.bottomPadding + 22.h, top: 8.h),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                      ).copyWith(top: 20.h, bottom: 10.h),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              msg,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyLarge(
                                context,
                                color: customColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            AppButton(
                              onClickEvent: onClickYes,
                              padding: EdgeInsets.zero,
                              backgroundColor: colors.surface,
                              text: textYes ?? context.translate("yes"),
                              textStyle: AppTextStyles.bodyLarge(
                                context,
                                color: colors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0.h,
                    left: 12.w,
                    child: GestureDetector(
                      onTap: onClickNo ?? () => Navigator.pop(context),
                      child: Container(
                        height: 32.h,
                        width: 32.h,
                        decoration: BoxDecoration(
                          color: colors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 1.r, color: customColors.border),
                        ),
                        child: SvgPicture.asset(
                          Assets.vectors.exit.path,
                          height: 24.h,
                          width: 24.h,
                          colorFilter: ColorFilter.mode(
                            customColors.textPrimary.withValues(alpha: 0.8),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(anim1),
          child: child,
        );
      },
    ).then((_) {
      if (onDialogClosed != null) {
        onDialogClosed();
      }
    });
  }
}
