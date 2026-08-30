import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_text_styles.dart';
import '../utils/extensions/context_extensions.dart';

class AppRadioWidget extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;

  final bool value;
  final VoidCallback onTap;

  final double? radius;
  final double fontSize;

  final Color? textColor;
  final Color? background;

  final TextDirection? textDirection;
  final EdgeInsetsGeometry? margin;

  const AppRadioWidget({
    super.key,
    this.title,
    this.titleWidget,
    required this.value,
    required this.onTap,
    this.radius,
    this.fontSize = 12,
    this.textColor,
    this.background,
    this.textDirection,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final customColors = context.customColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius?.r ?? 999),
      child: Container(
        margin: margin,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        color: background ?? Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: textDirection,
          children: [
            Container(
              height: 18.h,
              width: 18.h,
              padding: EdgeInsets.all(3.r),
              decoration: BoxDecoration(
                color: colors.surface,
                shape: radius == null ? BoxShape.circle : BoxShape.rectangle,
                borderRadius:
                    radius != null ? BorderRadius.circular(radius!.r) : null,
                border: Border.all(
                  width: 1.r,
                  color: value ? colors.primary : customColors.border,
                ),
              ),
              child: value
                  ? Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.primary,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: titleWidget ??
                  Text(
                    title ?? "",
                    style: AppTextStyles.subTitle(
                      context,
                      fontSize: fontSize,
                      color: textColor ?? customColors.primarySoft,
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
