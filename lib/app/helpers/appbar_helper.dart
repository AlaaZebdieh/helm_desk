import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_text_styles.dart';
import '../widgets/app_icon_button.dart';
import '../utils/extensions/context_extensions.dart';

class AppBarHelper {
  /// Builds a customizable AppBar
  static PreferredSizeWidget build(
    BuildContext context, {
    Key? key,
    String title = "",
    double height = 56, // default Material AppBar height
    double leadingWidth = 55,
    double titleSpacing = 0,
    double elevation = 0,
    double scrolledUnderElevation = 0,
    bool centerTitle = true,
    Widget? leading,
    Widget? flexibleSpace,
    List<Widget>? actions,
    Widget? titleWidget,
    Color? backgroundColor,
    Color? surfaceTintColor,
    Color? iconBackColor,
    Color? systemNavigationBarColor,
    Brightness statusBarIconBrightness = Brightness.dark,
    Brightness statusBarBrightness = Brightness.light,
    Brightness systemNavigationBarIconBrightness = Brightness.dark,
  }) {
    final colors = context.colors;

    /// Default leading button
    Widget? defaultLeading = Navigator.canPop(context)
        ? AppIconButton(
            onClickEvent: () => Navigator.pop(context),
            iconColor: iconBackColor ?? colors.surface,
            flipX: context.isArabic,
            iconWidth: 16.w,
            iconHeight: 16.w,
          )
        : null;

    /// Default title widget if not provided
    Widget effectiveTitle =
        titleWidget ?? Text(title, style: AppTextStyles.titleLarge(context));

    return PreferredSize(
      preferredSize: Size(context.width, height.h),
      child: AppBar(
        key: key,
        toolbarHeight: height.h,
        leadingWidth: leadingWidth.w,
        titleSpacing: titleSpacing.w,
        elevation: elevation,
        scrolledUnderElevation: scrolledUnderElevation,
        centerTitle: centerTitle,
        backgroundColor: backgroundColor ?? Colors.transparent,
        surfaceTintColor: surfaceTintColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: systemNavigationBarColor ?? colors.surface,
          statusBarIconBrightness: statusBarIconBrightness,
          statusBarBrightness: statusBarBrightness,
          systemNavigationBarIconBrightness: systemNavigationBarIconBrightness,
        ),
        flexibleSpace: flexibleSpace,
        leading: leading ?? defaultLeading ?? const SizedBox.shrink(),
        title: effectiveTitle,
        actions: actions,
      ),
    );
  }
}
