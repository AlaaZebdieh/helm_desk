import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_text_styles.dart';
import '../helpers/loading_helper.dart';
import '../utils/extensions/context_extensions.dart';

class AppButton extends StatelessWidget {
  final String? text;
  final double radius;
  final double? height;
  final double? width;
  final Widget? child;
  final TextStyle? textStyle;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onClickEvent;
  final List<BoxShadow>? boxShadow;
  final bool isLoading;

  const AppButton({
    super.key,
    this.text,
    this.radius = 10,
    this.height,
    this.width,
    this.child,
    this.textStyle,
    this.gradient,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 0,
    this.padding,
    this.margin,
    this.onClickEvent,
    this.boxShadow,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final customColors = context.customColors;

    return Container(
      height: height ?? 48.h,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null
            ? (onClickEvent == null
                  ? customColors.disabled
                  : backgroundColor ?? colors.primary)
            : null,
        borderRadius: BorderRadius.circular(radius.r),
        boxShadow: boxShadow,
        border: borderWidth > 0
            ? Border.all(
                color: borderColor ?? colors.primary,
                width: borderWidth.r,
              )
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius.r),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onClickEvent,
            child: Padding(
              padding:
                  padding ??
                  EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
              child: Center(
                child: isLoading
                    ? LoadingHelper.circular(context, strokeWidth: 2)
                    : (child ??
                          Text(
                            text ?? "",
                            textAlign: TextAlign.center,
                            style:
                                textStyle ??
                                AppTextStyles.button(
                                  context,
                                  color: colors.surface,
                                ),
                          )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
