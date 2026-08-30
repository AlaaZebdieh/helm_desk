import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/assets.gen.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/extensions/context_extensions.dart';

import 'app_icon_button.dart';

class AppErrorWidget extends StatelessWidget {
  final String? mainText;
  final IconData? icon;
  final VoidCallback? onPress;

  const AppErrorWidget({
    super.key,
    this.mainText,
    this.icon = Icons.error_outline,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(icon, color: AppColors.error, size: 170.w),
          SizedBox(height: 16.h),
          Text(
            mainText ?? context.translate('unexpected_error'),
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium(
              context,
              color: context.customColors.textPrimary,
            ),
          ),
          SizedBox(height: 35.h),
          Text(
            context.translate("try_again"),
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium(
              context,
              color: context.customColors.textSecondary,
            ),
          ),
          SizedBox(height: 12.h),
          AppIconButton(
            onClickEvent: onPress ?? () {},
            backgroundColor: Colors.transparent,
            shape: BoxShape.circle,
            iconHeight: 50.h,
            iconColor: AppColors.error,
            icon: Assets.vectors.refresh,
          ),
        ],
      ),
    );
  }
}
